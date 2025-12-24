{
  lib,
  python3,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  desktop-file-utils,
  gobject-introspection,
  blueprint-compiler,
  gtk4,
  libadwaita,
  gst_all_1,
  file,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "chronograph";
  version = "5.3.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Dzheremi2";
    repo = "Chronograph";
    rev = "v${version}";
    hash = "sha256-xSvlvDXKJaL4sKQE+h9XkffFm3/1rHROlGxZgerBlNg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    gobject-introspection
    blueprint-compiler
  ];

  buildInputs = [
    gtk4
    libadwaita
    file
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  dependencies = with python3.pkgs; [
    pygobject3
    mutagen
    python-magic
    requests
    pillow
    pyyaml
    httpx
  ];

  mesonFlags = [ "-Dprofile=release" ];

  # chronograph is a GTK application
  dontUsePythonImportsCheck = true;

  meta = {
    description = "GTK4/Libadwaita lyrics synchronization tool";
    longDescription = ''
      Chronograph is an open-source application designed for accurately syncing
      lyrics with audio timestamps. It supports line-by-line and word-by-word
      synchronization, and can publish directly to LRCLib for sharing with the
      community.
    '';
    homepage = "https://github.com/Dzheremi2/Chronograph";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ DuppyBad ];
    mainProgram = "chronograph";
    platforms = lib.platforms.linux;
  };
}
