{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gettext,
  gobject-introspection,
  wrapGAppsHook4,
  glib,
  gtk4,
  libadwaita,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "whisp";
  version = "1.3.7";

  format = "other";

  src = fetchFromGitHub {
    owner = "tanaybhomia";
    repo = "Whisp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FcKRgC78XMKUN02hZ8KCAGrhDWoFj4AlTL7GiRdwAhU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
  ];

  # Upstream's meson tests shell out to appstreamcli/desktop-file-validate for
  # metadata linting; they add nothing to the packaged output.
  doCheck = false;

  # Let the single Python wrapper carry the GApps environment (GI_TYPELIB_PATH,
  # XDG_DATA_DIRS) instead of wrapping twice.
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "The Anti-Note for GNOME, a fluid gesture-driven scratchpad built for speed";
    homepage = "https://github.com/tanaybhomia/Whisp";
    changelog = "https://github.com/tanaybhomia/Whisp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kevinpita ];
    mainProgram = "whisp";
    platforms = lib.platforms.linux;
  };
})
