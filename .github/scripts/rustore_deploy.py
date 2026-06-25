#!/usr/bin/env python3
"""
RuStore Publisher API — deploy script.

API flow:
  1. Sign  (SHA512withRSA) → POST /public/auth  → JWE token
  2. POST  /public/v1/application/{pkg}/version  → versionId
  3. POST  /public/v1/application/{pkg}/version/{id}/apk  → upload APK
  4. POST  /public/v1/application/{pkg}/version/{id}/commit → submit for review

GitHub Secrets used:
  RUSTORE_COMPANY_ID  – Key ID (or Company ID) from RuStore Console → Settings → API Keys
  RUSTORE_PRIVATE_KEY – RSA private key PEM from the same page
  PACKAGE_NAME        – ru.habitify.tracker
  APK_PATH            – build/app/outputs/flutter-apk/app-release.apk
  WHATS_NEW           – set to HEAD commit message by the workflow
  BUILD_NUMBER        – github.run_number
"""

import base64
import datetime
import os
import sys

import requests
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding as asym_padding

API = "https://public-api.rustore.ru/public"


# ── helpers ──────────────────────────────────────────────────────────────────

def die(msg: str) -> None:
    print(f"::error::{msg}", file=sys.stderr)
    sys.exit(1)


def check_response(resp: requests.Response, step: str) -> dict:
    try:
        data = resp.json()
    except Exception:
        die(f"{step}: non-JSON response (HTTP {resp.status_code}): {resp.text[:400]}")

    code = data.get("code", "")
    if code != "OK":
        die(f"{step} failed (code={code}): {data.get('message') or data}")

    print(f"  ✓ {step}")
    return data


# ── step 1: authenticate ─────────────────────────────────────────────────────

def _sign(rustore_id: str, timestamp: str, private_key_pem: str) -> str:
    """Return base64-encoded SHA512withRSA signature of (id + timestamp)."""
    pem = private_key_pem.strip()
    if not pem.startswith("-----"):
        # RuStore Console sometimes exports raw base64 without PEM headers.
        raw = base64.b64decode(pem)
        pem = (
            "-----BEGIN PRIVATE KEY-----\n"
            + base64.b64encode(raw).decode()
            + "\n-----END PRIVATE KEY-----"
        )
    private_key = serialization.load_pem_private_key(pem.encode(), password=None)
    sig = private_key.sign(
        (rustore_id + timestamp).encode("utf-8"),
        asym_padding.PKCS1v15(),
        hashes.SHA512(),
    )
    return base64.b64encode(sig).decode()


def get_token(rustore_id: str, private_key_pem: str) -> str:
    """
    Obtain a JWE token valid for 900 s.

    Uses the current RuStore API (post-2024): `keyId` field only.
    The keyId is found in RuStore Console → Settings → API Keys.
    """
    tz = datetime.timezone(datetime.timedelta(hours=3))  # Moscow time (+03:00)
    timestamp = datetime.datetime.now(tz).strftime("%Y-%m-%dT%H:%M:%S.000+03:00")
    signature_b64 = _sign(rustore_id, timestamp, private_key_pem)

    payload = {
        "keyId":     rustore_id,
        "timestamp": timestamp,
        "signature": signature_b64,
    }

    resp = requests.post(f"{API}/auth", json=payload, timeout=30)
    try:
        data = resp.json()
    except Exception:
        die(f"Auth: non-JSON response (HTTP {resp.status_code}): {resp.text[:400]}")

    code = data.get("code", "")
    if code != "OK":
        die(
            f"Auth failed (code={code}): {data.get('message') or data}\n"
            "  → Check secret RUSTORE_COMPANY_ID: it must be the KEY ID\n"
            "    (not the numeric company ID) from:\n"
            "    RuStore Console → Settings → API Keys → column 'ID ключа'"
        )

    print("  ✓ Auth")
    return data["body"]["jwe"]


# ── step 2: create version draft ─────────────────────────────────────────────

def create_draft(token: str, package: str, whats_new: str) -> int:
    notes = (whats_new or "Обновление приложения").strip()[:500]

    resp = requests.post(
        f"{API}/v1/application/{package}/version",
        headers={
            "Public-Token": token,
            "Content-Type": "application/json",
        },
        json={
            "appName":     "Трекер привычек",
            "appType":     "MAIN",
            "ageLegal":    "0+",
            "whatsNew":    notes,
            "publishType": "INSTANTLY",
        },
        timeout=30,
    )
    data = check_response(resp, "Create draft")
    version_id = int(data["body"])
    print(f"     versionId = {version_id}")
    return version_id


# ── step 3: upload APK ───────────────────────────────────────────────────────

def upload_apk(token: str, package: str, version_id: int, apk_path: str) -> None:
    size_mb = os.path.getsize(apk_path) / 1_048_576
    print(f"     Uploading {os.path.basename(apk_path)} ({size_mb:.1f} MB)…")

    with open(apk_path, "rb") as f:
        resp = requests.post(
            f"{API}/v1/application/{package}/version/{version_id}/apk"
            "?servicesType=Unknown&isMainApk=true",
            headers={"Public-Token": token},
            files={"file": (os.path.basename(apk_path), f, "application/octet-stream")},
            timeout=300,
        )
    check_response(resp, "Upload APK")


# ── step 4: commit draft for review ─────────────────────────────────────────

def commit(token: str, package: str, version_id: int) -> None:
    resp = requests.post(
        f"{API}/v1/application/{package}/version/{version_id}/commit"
        "?priorityUpdate=0",
        headers={"Public-Token": token},
        timeout=30,
    )
    check_response(resp, "Submit for review")


# ── main ─────────────────────────────────────────────────────────────────────

def main() -> None:
    rustore_id   = os.environ.get("RUSTORE_COMPANY_ID", "").strip()
    private_key  = os.environ.get("RUSTORE_PRIVATE_KEY", "").strip()
    package      = os.environ.get("PACKAGE_NAME", "ru.habitify.tracker").strip()
    apk_path     = os.environ.get("APK_PATH", "build/app/outputs/flutter-apk/app-release.apk")
    whats_new    = os.environ.get("WHATS_NEW", "")
    build_number = os.environ.get("BUILD_NUMBER", "?")

    # Validate required secrets
    missing = [n for n, v in [("RUSTORE_COMPANY_ID", rustore_id),
                                ("RUSTORE_PRIVATE_KEY", private_key)] if not v]
    if missing:
        die(f"Missing secrets: {', '.join(missing)}. "
            f"Add them in Settings → Secrets → Actions.")

    if not os.path.exists(apk_path):
        die(f"APK not found: {apk_path}")

    print(f"\n── RuStore deploy  build #{build_number}  pkg={package} ──")

    token      = get_token(rustore_id, private_key)
    version_id = create_draft(token, package, whats_new)
    upload_apk(token, package, version_id, apk_path)
    commit(token, package, version_id)

    print(f"\n🚀  Build #{build_number} submitted to RuStore for review!")


if __name__ == "__main__":
    main()
