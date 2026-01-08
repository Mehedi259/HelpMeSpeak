plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
        import java.io.FileInputStream

        android {
            namespace = "com.example.helpmespeak"
            compileSdk = 36  // Updated from 34 to 36
            ndkVersion = "27.0.12077973"

            compileOptions {
                sourceCompatibility = JavaVersion.VERSION_11
                targetCompatibility = JavaVersion.VERSION_11
            }

            kotlinOptions {
                jvmTarget = "11"
            }

            // Load keystore from key.properties
            val keystoreProperties = Properties()
            val keystorePropertiesFile = rootProject.file("key.properties")
            if (keystorePropertiesFile.exists()) {
                keystoreProperties.load(FileInputStream(keystorePropertiesFile))
            }

            defaultConfig {
                applicationId = "com.example.helpmespeak"
                minSdk = flutter.minSdkVersion
                targetSdk = 34
                versionCode = 1
                versionName = "1.0.0"
            }

            signingConfigs {
                create("release") {
                    keyAlias = keystoreProperties["keyAlias"] as String?
                    keyPassword = keystoreProperties["keyPassword"] as String?
                    storeFile = keystorePropertiesFile.parentFile?.let {
                        file("${it.path}/${keystoreProperties["storeFile"]}")
                    }
                    storePassword = keystoreProperties["storePassword"] as String?
                }
            }

            buildTypes {
                release {
                    signingConfig = signingConfigs.getByName("release")
                    isMinifyEnabled = true
                    isShrinkResources = true
                    proguardFiles(
                        getDefaultProguardFile("proguard-android-optimize.txt"),
                        "proguard-rules.pro"
                    )
                }
            }
        }

flutter {
    source = "../.."
}

dependencies {
    implementation("com.android.billingclient:billing:6.1.0")
    implementation("com.android.billingclient:billing-ktx:6.1.0")
}