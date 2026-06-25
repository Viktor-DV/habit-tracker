plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "ru.habitify.tracker"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Required by flutter_local_notifications (java.time backport).
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "ru.habitify.tracker"
        // Android 8.0+ (API 26+) per product spec — exact alarms, background services.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Signing credentials are stored in android/key.properties (gitignored).
    // Copy key.properties.example → key.properties and fill in your values.
    val keyProps = java.util.Properties()
    val keyPropsFile = rootProject.file("key.properties")
    if (keyPropsFile.exists()) keyProps.load(keyPropsFile.inputStream())

    signingConfigs {
        create("release") {
            storeFile     = keyProps["storeFile"]?.let { file(it as String) }
            storePassword = keyProps["storePassword"] as String?
            keyAlias      = keyProps["keyAlias"]      as String?
            keyPassword   = keyProps["keyPassword"]   as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
