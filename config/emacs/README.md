# Install the fonts for Doom statusbar
```
M-x all-the-icons-install-fonts
```

# Android Port
https://marek-g.github.io/posts/tips_and_tricks/emacs_on_android/
https://gist.github.com/henriquemenezes/70feb8fff20a19a65346e48786bedb8f

, keytool -genkey -v -keystore debug.keystore -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000 -dname "C=US, O=Android, CN=Android Debug"
get com.termux.nix_188035.apk .
get emacs-30.0.50-29-arm64-v8a.apk .
, apktool d com.termux.nix_188035.apk
, apktool b com.termux.nix_188035 -o com.termux.nix_188035_signed.apk
, jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ./debug.keystore com.termux.nix_188035_signed.apk androiddebugkey
, apktool d emacs-30.0.50-29-arm64-v8a.apk
modify emacs-30.0.50-29-arm64-v8a/AndroidManifest.xml from string in com.termux.nix_188035/AndroidManifest.xml
get com.termux.nix_188035/res/values/strings.xml and move it to emacs
, apktool b emacs-30.0.50-29-arm64-v8a -o emacs-30.0.50-29-arm64-v8a_signed.apk
, jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ./debug.keystore emacs-30.0.50-29-arm64-v8a_signed.apk androiddebugkey
