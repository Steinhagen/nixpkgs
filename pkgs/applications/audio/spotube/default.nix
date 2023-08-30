{ lib
, flutter
, fetchFromGitHub
, libnotify
}:

flutter.buildFlutterApplication rec {
  pname = "spotube";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "KRTirtho";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jgldI1M2GG1Bd8Jh5wyAatFOqt/LL1mNh6eEfOkktpw=";
  };

  pubspecLockFile = ./pubspec.lock;
  depsListFile = ./deps.json;
  vendorHash = "sha256-sHN/0mbVxnoyn/VEYK678mTSX9xWlwYJeUY8780WBEE=";

  buildInputs = [
    libnotify
  ];

  meta = with lib; {
    description = "Open source Spotify client";
    longDescription = ''
      Spotube is an open source, cross-platform Spotify client that
      doesn't require Premium nor uses Electron
    '';
    homepage = "https://spotube.netlify.app/";
    license = lib.licenses.bsdOriginal;
    maintainers = with maintainers; [ rapiteanu ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ sourceTypes.fromSource ];
  };
}
