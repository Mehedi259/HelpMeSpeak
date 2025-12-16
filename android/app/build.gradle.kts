// android/app/build.gradle.kts

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
        import java.io.FileInputStream

        android {
            namespace = "com.example.helpmespeak"
            compileSdk = flutter.compileSdkVersion
            ndkVersion = "27.0.12077973"

            compileOptions {
                sourceCompatibility = JavaVersion.VERSION_11
                targetCompatibility = JavaVersion.VERSION_11
            }

            kotlinOptions {
                jvmTarget = "11"
            }

            // -------------------------------
            // Load keystore from key.properties
            // -------------------------------
            val keystoreProperties = Properties()
            val keystorePropertiesFile = rootProject.file("key.properties")
            if (keystorePropertiesFile.exists()) {
                keystoreProperties.load(FileInputStream(keystorePropertiesFile))
            }

            defaultConfig {
                applicationId = "com.example.helpmespeak"
                minSdk = 21  // Required for in_app_purchase
                targetSdk = flutter.targetSdkVersion
                versionCode = flutter.versionCode
                versionName = flutter.versionName
            }

            signingConfigs {
                create("release") {
                    keyAlias = keystoreProperties["keyAlias"] as String?
                    keyPassword = keystoreProperties["keyPassword"] as String?
                    storeFile = file(keystoreProperties["storeFile"] ?: "")
                    storePassword = keystoreProperties["storePassword"] as String?
                }
            }

            buildTypes {
                release {
                    signingConfig = signingConfigs.getByName("release")
                    isMinifyEnabled = false
                    isShrinkResources = false
                    proguardFiles(
                        getDefaultProguardFile("proguard-android-optimize.txt"),
                        "proguard-rules.pro"
                    )
                }

                debug {
                    signingConfig = signingConfigs.getByName("release") // Optional
                }
            }
        }

flutter {
    source = "../.."
}

dependencies {
    // Google Play Billing Library (for in-app purchases)
    implementation("com.android.billingclient:billing:6.1.0")
    implementation("com.android.billingclient:billing-ktx:6.1.0")
}