import java.util.Properties;

plugins {
    id("com.android.application")
    id("kotlin-android")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { localProperties.load(it) }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"
val googleMapsApiKey = localProperties.getProperty("google.maps.apiKey") ?: ""

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "com.pantoo.presensi"
    compileSdk = 36
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
    }

    flavorDimensions += "app"

    productFlavors {
        create("production") {
            dimension = "app"
            applicationId = "com.pantoo.presensi"
            versionCode = flutterVersionCode.toInt()
            versionName = flutterVersionName
            resValue("string", "app_name", "Pantoo HR")
            manifestPlaceholders["usesCleartextTraffic"] = "false"
            manifestPlaceholders["googleMapsApiKey"] = googleMapsApiKey
        }

        create("development") {
            dimension = "app"
            applicationId = "com.pantoo.presensi.dev"
            versionCode = flutterVersionCode.toInt()
            versionName = flutterVersionCode.toString()
            resValue("string", "app_name", "Pantoo HR [dev]")
            manifestPlaceholders["usesCleartextTraffic"] = "true"
            manifestPlaceholders["googleMapsApiKey"] = googleMapsApiKey
        }
    }

    defaultConfig {
        applicationId = "com.pantoo.presensi"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = 1
        versionName = "1.3.0"
        resValue("string", "app_name", "Pantoo HR")
    }

    signingConfigs {
        if (keystoreProperties["storeFile"] != null) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
            signingConfig = if (keystoreProperties["storeFile"] != null) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
