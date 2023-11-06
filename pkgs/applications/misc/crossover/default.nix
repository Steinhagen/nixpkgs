{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, makeWrapper
, pkgs
, steam
, wrapGAppsHook
, gobject-introspection
, glibc_multi
, gsettings-desktop-schemas
, sane-backends
, libunwind
}:
let
  gds = gsettings-desktop-schemas;
  steam-run = (steam.override {
    extraPkgs = p: with p; [
    ];
    extraLibraries = p: with p; [
      gnutls
      openldap
      gmp
      openssl
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-plugins-base
      libunwind
      sane-backends
      libgphoto2
      openal
      apulse

      libpcap
      ocl-icd
      libxcrypt-legacy
    ];
  }).run;
  version = "24.0.4-1";

in

stdenv.mkDerivation rec {
  pname = "crossover";
  inherit version;

  buildInputs = [
    steam-run
    pkgs.gtkdialog
    pkgs.gtk3
    pkgs.vte
    sane-backends # for libsane.so.1
    libunwind # for libunwind.so.8
    (pkgs.python3.withPackages (p: with p; [
      pygobject3
      gst-python
      dbus-python
      pycairo
    ]))
  ];

  src = fetchurl {
    url = "https://media.codeweavers.com/pub/crossover/cxlinux/demo/crossover_${version}.deb";
    hash = "sha256-/2vhmhdrurTm+K1MzoU/TCiSrmBrfq5j86PLt1ZHqdw=";
  };

  nativeBuildInputs = [
    glibc_multi
    autoPatchelfHook
    wrapGAppsHook
    gobject-introspection
    makeWrapper
    dpkg
  ];
  autoPatchelfIgnoreMissingDeps = [
    "libpcsclite.so.1"
    "libpulse.so.0"
    "libOpenCL.so.1"
    "libusb-1.0.so.0"
    "libgphoto2.so.6"
    "libgphoto2_port.so.12"
    "libcrypt.so.1"
    "libgstvideo-1.0.so.0"
    "libgstaudio-1.0.so.0"
    "libgstbase-1.0.so.0"
    "libgsttag-1.0.so.0"
    "libgstreamer-1.0.so.0"
    "libasound.so.2"
    "libcapi20.so.3"
  ];

  unpackCmd = "dpkg -x $src source";

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  installPhase = ''
    mkdir -p $out/opt
    mv opt/* $out/opt/

    mv usr $out/usr

    makeWrapper ${steam-run}/bin/steam-run $out/bin/crossover \
      --add-flags $out/opt/cxoffice/bin/crossover \
      --set-default GSETTINGS_SCHEMA_DIR "${gds}/share/gsettings-schemas/${gds.pname}-${gds.version}/glib-2.0/schemas"

    runHook preFixup
    runHook postInstall
  '';

  meta = with lib; {
    description = "Run your Windows® app on MacOS, Linux or ChromeOS";
    maintainers = with maintainers; [ yswtrue ];
    license = licenses.colg;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
