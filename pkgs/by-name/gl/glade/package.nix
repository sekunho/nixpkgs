{
  stdenv,
  lib,
  gettext,
  fetchurl,
  python3,
  meson,
  ninja,
  pkg-config,
  gtk3,
  glib,
  gjs,
  enableWebkit2gtk ? stdenv.hostPlatform.isLinux,
  webkitgtk_4_1,
  gobject-introspection,
  wrapGAppsHook3,
  itstool,
  libxml2,
  docbook-xsl-nons,
  docbook_xml_dtd_42,
  gnome,
  adwaita-icon-theme,
  gdk-pixbuf,
  libxslt,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation rec {
  pname = "glade";
  version = "3.40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/glade/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "McmtrqhJlyq5UXtWThmsGZd8qXdYsQntwxZwCPU+PZw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    wrapGAppsHook3
    docbook-xsl-nons
    docbook_xml_dtd_42
    libxslt
    libxml2
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    glib
    gjs
    libxml2
    python3
    python3.pkgs.pygobject3
    gsettings-desktop-schemas
    gdk-pixbuf
    adwaita-icon-theme
  ]
  ++ lib.optionals enableWebkit2gtk [
    webkitgtk_4_1
  ];

  mesonFlags = [
    (lib.mesonEnable "webkit2gtk" enableWebkit2gtk)
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace 'webkit2gtk-4.0' 'webkit2gtk-4.1'
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/glade";
    description = "User interface designer for GTK applications";
    teams = [ teams.gnome ];
    license = licenses.lgpl2;
    platforms = platforms.unix;
  };
}
