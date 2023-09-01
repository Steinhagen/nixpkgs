{ lib
, fetchFromGitHub
, glib-networking
, gst_all_1
, gtk3
, libappindicator
, libayatana-appindicator
, libsoup
, libX11
, openssl
, pcre2
, pkg-config
, rustPlatform
, wrapGAppsHook
, webkitgtk
}:

rustPlatform.buildRustPackage rec {
  name = "dorion";
  version = "1.0.1";

  sourceRoot = "${src.name}/src-tauri";

  src = fetchFromGitHub {
    owner = "SpikeHD";
    repo = "Dorion";
    rev = "v${version}";
    hash = "sha256-s0VBV36GkLwcug4lBVipWVwjLi33Ak8hBXIv+qko7ik=";
  };

  cargoHash = "sha256-djoNNwpORgOkvkl1pYTleVRQQH1+4hNA9d7UIxb4acQ=";

  nativeBuildInputs = [ pkg-config ];
  # nativeBuildInputs = [
  #   dpkg
  #   wrapGAppsHook
  #   autoPatchelfHook
  # ];

  buildInputs = [
    glib-networking
    gtk3
    libsoup
    libX11
    openssl
    pcre2
    webkitgtk
  ];
  # buildInputs = [
  #   webkitgtk
  #   gst_all_1.gst-plugins-base
  #   gst_all_1.gst-plugins-good
  #   gst_all_1.gst-plugins-bad
  # ];

  # runtimeDependencies = [
  #   libappindicator
  #   libayatana-appindicator
  #   glib-networking
  # ];

  # installPhase = ''
  #   mkdir -p $out/bin
  #   mv html icons injection plugins themes dorion $out/bin
  # '';

  meta = with lib; {
    description = "Tiny alternative Discord client with a smaller footprint, themes and plugins, multi-profile, and more";
    homepage = "https://github.com/SpikeHD/Dorion";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.rapiteanu ];
  };
}