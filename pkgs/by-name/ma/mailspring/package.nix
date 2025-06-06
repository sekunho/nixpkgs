{
  lib,
  stdenv,
  callPackage,
}:
let
  pname = "mailspring";
  version = "1.15.1";

  meta = {
    description = "Beautiful, fast and maintained fork of Nylas Mail by one of the original authors";
    downloadPage = "https://github.com/Foundry376/Mailspring";
    homepage = "https://getmailspring.com";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      Mailspring is an open-source mail client forked from Nylas Mail and built with Electron.
      Mailspring's sync engine runs locally, but its source is not open.
    '';
    mainProgram = "mailspring";
    maintainers = with lib.maintainers; [ toschmidt ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  linux = callPackage ./linux.nix { inherit pname version meta; };
  darwin = callPackage ./darwin.nix { inherit pname version meta; };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
