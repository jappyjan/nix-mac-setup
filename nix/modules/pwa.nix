{ lib, pkgs, ... }:
let
  pwaGithubUrl = "https://github.com";
  pwaCrunchyrollUrl = "https://crunchyroll.com";
  pwaSimplyPrintUrl = "https://simplyprint.io/panel/printers";
  pwaGithubIconUrl = "https://www.google.com/s2/favicons?domain=github.com&sz=256";
  pwaCrunchyrollIconUrl = "https://www.google.com/s2/favicons?domain=crunchyroll.com&sz=256";
  pwaSimplyPrintIconUrl = "https://www.google.com/s2/favicons?domain=simplyprint.io&sz=256";
in
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "pwa-github" ''
      exec /usr/bin/open -na "Brave Browser" --args --app=${pwaGithubUrl} --new-window
    '')
  ];

  system.activationScripts.extraActivation.text = lib.mkAfter ''
    /bin/mkdir -p "/Applications/PWAs"

    create_pwa_app() {
      local app_name="$1"
      local app_url="$2"
      local app_icon_url="$3"
      local app_dir="/Applications/PWAs/''${app_name}.app"
      local macos_dir="''${app_dir}/Contents/MacOS"
      local resources_dir="''${app_dir}/Contents/Resources"

      /bin/mkdir -p "$macos_dir" "$resources_dir"

      /bin/cat > "''${app_dir}/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>CFBundleDisplayName</key>
    <string>''${app_name}</string>
    <key>CFBundleName</key>
    <string>''${app_name}</string>
    <key>CFBundleIdentifier</key>
    <string>local.pwa.''${app_name}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleExecutable</key>
    <string>''${app_name}</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>LSUIElement</key>
    <false/>
  </dict>
</plist>
EOF

      if [ -n "''${app_icon_url}" ]; then
        icon_png="''${resources_dir}/AppIcon.png"
        icon_icns="''${resources_dir}/AppIcon.icns"
        iconset_dir="''${resources_dir}/AppIcon.iconset"
        if /usr/bin/curl -fsSL "''${app_icon_url}" -o "''${icon_png}"; then
          /bin/mkdir -p "''${iconset_dir}"
          /usr/bin/sips -z 16 16 "''${icon_png}" --out "''${iconset_dir}/icon_16x16.png" >/dev/null 2>&1 || true
          /usr/bin/sips -z 32 32 "''${icon_png}" --out "''${iconset_dir}/icon_16x16@2x.png" >/dev/null 2>&1 || true
          /usr/bin/sips -z 32 32 "''${icon_png}" --out "''${iconset_dir}/icon_32x32.png" >/dev/null 2>&1 || true
          /usr/bin/sips -z 64 64 "''${icon_png}" --out "''${iconset_dir}/icon_32x32@2x.png" >/dev/null 2>&1 || true
          /usr/bin/sips -z 128 128 "''${icon_png}" --out "''${iconset_dir}/icon_128x128.png" >/dev/null 2>&1 || true
          /usr/bin/sips -z 256 256 "''${icon_png}" --out "''${iconset_dir}/icon_128x128@2x.png" >/dev/null 2>&1 || true
          /usr/bin/sips -z 256 256 "''${icon_png}" --out "''${iconset_dir}/icon_256x256.png" >/dev/null 2>&1 || true
          /usr/bin/sips -z 512 512 "''${icon_png}" --out "''${iconset_dir}/icon_256x256@2x.png" >/dev/null 2>&1 || true
          /usr/bin/sips -z 512 512 "''${icon_png}" --out "''${iconset_dir}/icon_512x512.png" >/dev/null 2>&1 || true
          /usr/bin/sips -z 1024 1024 "''${icon_png}" --out "''${iconset_dir}/icon_512x512@2x.png" >/dev/null 2>&1 || true
          /usr/bin/iconutil -c icns "''${iconset_dir}" -o "''${icon_icns}" >/dev/null 2>&1 || true
          /bin/rm -rf "''${iconset_dir}" "''${icon_png}"
        fi
      fi

      /bin/cat > "''${macos_dir}/''${app_name}" <<EOF
#!/bin/sh
exec /usr/bin/open -na "Brave Browser" --args --app="''${app_url}" --new-window
EOF

      /bin/chmod +x "''${macos_dir}/''${app_name}"
    }

    create_pwa_app "GitHub" "${pwaGithubUrl}" "${pwaGithubIconUrl}"
    create_pwa_app "Crunchyroll" "${pwaCrunchyrollUrl}" "${pwaCrunchyrollIconUrl}"
    create_pwa_app "SimplyPrint" "${pwaSimplyPrintUrl}" "${pwaSimplyPrintIconUrl}"
  '';
}
