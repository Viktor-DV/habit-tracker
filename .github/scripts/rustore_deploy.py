#!/usr/bin/env python3
"""
RuStore Publisher API — deploy script.

Flow:
  1. Sign (SHA512withRSA) → get JWE token
  2. Create version draft
  3. Upload APK
  4. Commit draft for review

Required env vars (set as GitHub Secrets):
  RUSTORE_KEY_ID      — Key ID from RuStore Console → Settings → API Keys
  RUSTORE_PRIVATE_KEY — PEM private key (RSA) from the same page
  PACKAGE_NAME        — e.g. ru.habitify.tracker
  APK_PATH            — path to .apk file
  WHATS_NEW           — release notes (auto-set to commit message)
  BUILD_NUMBER        — versionCode / CI run number
"""

import base64
import json
import os
import sys
import datetime

import requests
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding as asym_padding

API = "https://public-api.rustore.ru/public"

# ── helpers ──────────────────────────────────────────────────────────────────

def die(msg: str) -> None:
    print(f"::error::{msg}", file=sys.stderr)
    sys.exit(1)

def ok(resp: requests.Response, step: str) -> dict:
    try:
        data = resp.json()
    except Exception:
        die(f"{step}: non-JSON response ({resp.status_code}): {resp.text[:400]}")
    if data.get("code") != "OK":
        die(f"{step} failed: {data}")
    print(f"✓ {step}")
    return data

# ── 1. Auth ──────────────────────────────────────────────────────────────────

def get_token(key_id: str, private_key_pem: str) -> str:
    """Return JWE token valid for 900 s."""
    # Timestamp with Moscow offset (+03:00) — server rejects >60 s drift.
    tz = datetime.timezone(datetime.timedelta(hours=3))
    timestamp = datetime.datetime.now(tz).strftime("%Y-%m-%dT%H:%M:%S.000+03:00")

    message = (key_id + timestamp).encode("utf-8")

    # Load RSA private key — accepts both raw PEM and base64-wrapped PEM.
    pem = private_key_pem.strip()
    if not pem.startswith("-----"):
        # RuStore Console exports key without PEM headers sometimes.
        raw = base64.b64decode(pem)
        pem = (
            "-----BEGIN PRIVATE KEY-----\n"
            + base64.b64encode(raw).decode()
            + "\n-----END PRIVATE KEY-----"
        )

    private_key = serialization.load_pem_private_key(pem.encode(), password=None)
    signature_bytes = private_key.sign(message, asym_padding.PKCS1v15(), hashes.SHA512())
    signature_b64 = base64.b64encode(signature_bytes).decode()

    resp = requests.post(
        f"{API}/auth",
        json={"keyId": key_id, "timestamp": timestamp, "signature": signature_b64},
        timeout=30,
    )
    data = ok(resp, "Auth")
    return data["body"]["jwe"]

# ── 2. Create draft ───────────────────────────────────────────────────────────

def create_draft(token: str, package: str, whats_new: str) -> int:
    """Create a version draft and return its versionId."""
    # Truncate whatsNew — RuStore limit is 500 chars.
    notes = (whats_new or "Обновление приложения")[:500]

    resp = requests.post(
        f"{API}/v1/application/{package}/version",
        headers={"Public-Token": token, "Content-Type": "application/json"},
        json={
            "appName": "Трекер привычек",
            "appType": "MAIN",
            "ageLegal": "0+",
            "whatsNew": notes,
            "publishType": "INSTANTLY",
        },
        timeout=30,
    )
    data = ok(resp, "Create draft")
    version_id = data["body"]
    print(f"  versionId = {version_id}")
    return int(version_id)

# ── 3. Upload APK ─────────────────────────────────────────────────────────────

def upload_apk(token: str, package: str, version_id: int, apk_path: str) -> None:
    with open(apk_path, "rb") as apk_file:
        resp = requests.post(
            f"{API}/v1/application/{package}/version/{version_id}/apk"
            "?servicesType=Unknown&isMainApk=true",
            headers={"Public-Token": token},
            files={"file": (os.path.basename(apk_path), apk_file, "application/octet-stream")},
            timeout=300,  # large file — 5 min timeout
        )
    ok(resp, "Upload APK")

# ── 4. Commit ────────────────────────────────────────────────────────────────

def commit(token: str, package: str, version_id: int) -> None:
    resp = requests.post(
        f"{API}/v1/application/{package}/version/{version_id}/commit?priorityUpdate=0",
        headers={"Public-Token": token},
        timeout=30,
    )
    ok(resp, "Commit draft → moderation")

# ── main ─────────────────────────────────────────────────────────────────────

def main() -> None:
    key_id      = os.environ.get("RUSTORE_KEY_ID", "").strip()
    private_key = os.environ.get("RUSTORE_PRIVATE_KEY", "").strip()
    package     = os.environ.get("PACKAGE_NAME", "ru.habitify.tracker").strip()
    apk_path    = os.environ.get("APK_PATH", "build/app/outputs/flutter-apk/app-release.apk")
    whats_new   = os.environ.get("WHATS_NEW", "")
    build_num   = os.environ.get("BUILD_NUMBER", "?")

    for name, val in [("RUSTORE_KEY_ID", key_id), ("RUSTORE_PRIVATE_KEY", private_key)]:
        if not val:
            die(f"Secret {name} is empty. Add it in Settings → Secrets → Actions.")

    if not os.path.exists(apk_path):
        die(f"APK not found at {apk_path}. Check the build step.")

    apk_size_mb = os.path.getsize(apk_path) / 1_048_576
    print(f"Deploying build #{build_num}  APK {apk_size_mb:.1f} MB → {package}")

    token      = get_token(key_id, private_key)
    version_id = create_draft(token, package, whats_new)
    upload_apk(token, package, version_id, apk_path)
    commit(token, package, version_id)

    print(f"\n🚀  Build #{build_num} submitted for RuStore review!")

if __name__ == "__main__":
    main()
