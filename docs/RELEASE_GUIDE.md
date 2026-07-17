# Release Guide — Google Play Store

## 1. Buat keystore
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
Simpan file `.jks` di luar folder project (jangan sampai ter-commit).

## 2. Setup signing
1. Copy `docs/key.properties.example` → `android/key.properties`, isi sesuai keystore kamu.
2. Tambahkan `android/key.properties` ke `.gitignore` (sudah ada di project ini, cek ulang).
3. Edit `android/app/build.gradle`, tambahkan **di paling atas** (sebelum `android {`):
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```
4. Di dalam block `android { ... }`, tambahkan:
```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}
buildTypes {
    release {
        signingConfig signingConfigs.release
    }
}
```

## 3. Ganti applicationId
Di `android/app/build.gradle`, ganti `applicationId "com.example.hamster_run"` menjadi id unik kamu, contoh:
```gradle
applicationId "com.yourname.hamsterrun"
```

## 4. Build App Bundle
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

## 5. Upload ke Play Console
1. Buat app baru di [Play Console](https://play.google.com/console)
2. Isi Store listing (deskripsi, icon 512x512, feature graphic 1024x500, screenshot)
3. Tempel isi `docs/PRIVACY_POLICY.md` (host di GitHub Pages / raw link) ke field Privacy Policy URL
4. Isi Content rating & Data safety form
5. Upload `.aab` ke track **Internal testing** dulu → lolos → **Production**

## Host Privacy Policy gratis via GitHub Pages
```bash
# aktifkan GitHub Pages di repo (Settings > Pages > branch main /docs)
# URL jadi: https://username.github.io/hamster_run/PRIVACY_POLICY
```
