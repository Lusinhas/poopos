{
  lib,
  fetchurl,
  appimageTools,
  stdenv,
  _experimental-update-script-combinators,
  nix-update-script,
  widevine-cdm,
  enableWideVine ? false,
}:

let
  pname = "helium-browser";
  version = "0.14.5.1";

  sourceMap = {
    x86_64-linux = fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
      hash = "sha256-JM4Tm4Le9Xcfq3fFMEu/DIK6817FEgBQ2rSwY093F04=";
    };

    aarch64-linux = fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-arm64.AppImage";
      hash = "sha256-NStk0HDMTXOBgDTzvGkUcErGDu5WXrTjkxlytQ5jOBE=";
    };
  };

  extracted = appimageTools.extract {
    inherit pname version;

    src =
      sourceMap.${stdenv.hostPlatform.system}
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

    postExtract = lib.optionalString enableWideVine ''
      mkdir -p $out/opt/helium/WidevineCdm
      cp -a ${widevine-cdm}/share/google/chrome/WidevineCdm/* $out/opt/helium/WidevineCdm/
    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version;

  src = extracted;

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script {
      extraArgs = [
        "--system"
        "x86_64-linux"
        "--flake"
      ];
    })
    (nix-update-script {
      extraArgs = [
        "--system"
        "aarch64-linux"
        "--version"
        "skip"
        "--flake"
      ];
    })
  ];

  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    mkdir -p "$out/share/lib/helium"

    cp -r ${extracted}/opt/helium/locales "$out/share/lib/helium"
    cp -r ${extracted}/usr/share/* "$out/share"
    cp "${extracted}/helium.desktop" "$out/share/applications/${pname}.desktop"
    sed -i 's|^Exec=helium\b|Exec=${pname}|' "$out/share/applications/${pname}.desktop"
  '';

  meta = {
    description = "Private, fast, and honest web browser based on Chromium";
    homepage = "https://github.com/imputnet/helium-chromium";
    changelog = "https://github.com/imputnet/helium-linux/releases/tag/${version}";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    license = if enableWideVine then lib.licenses.unfree else lib.licenses.gpl3Only;
    mainProgram = "helium-browser";
  };
}
