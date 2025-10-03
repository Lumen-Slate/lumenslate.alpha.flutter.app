import java.util.Properties

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    id("com.google.firebase.firebase-perf")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Load key properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "com.harentortoise.lumenslate"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.3.13750724"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.harentortoise.lumenslate"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        resValue("string", "app_name", "LumenSlate")
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists() && keystoreProperties.getProperty("keyAlias") != null) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String

                // Verify keystore file exists
                val keystoreFile = file(keystoreProperties["storeFile"] as String)
                if (!keystoreFile.exists()) {
                    throw GradleException("Keystore file not found: ${keystoreFile.absolutePath}")
                }
            } else {
                throw GradleException("key.properties file missing or incomplete")
            }
        }
    }

    buildTypes {
        debug {
            isDebuggable = true
            signingConfig = signingConfigs.getByName("debug")

            resValue("string", "app_name", "LumenSlate Debug")

            manifestPlaceholders["crashlyticsCollectionEnabled"] = false
            manifestPlaceholders["performanceCollectionEnabled"] = false
        }
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            // Use release signing
            signingConfig = signingConfigs.getByName("release")

            resValue("string", "app_name", "LumenSlate")

            manifestPlaceholders["crashlyticsCollectionEnabled"] = true
            manifestPlaceholders["performanceCollectionEnabled"] = true
        }
    }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.3.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-crashlytics")
    implementation("com.google.firebase:firebase-perf")
    implementation("com.google.android.play:integrity:1.5.0")
    implementation("com.android.billingclient:billing:6.0.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

flutter {
    source = "../.."
}