{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libgcrypt,
  libgpg-error,
  libtasn1,

  # Optional Dependencies
  pam ? null,
  libidn ? null,
  gnutls ? null,
}:

let
  shouldUsePkg =
    pkg: if pkg != null && lib.meta.availableOn stdenv.hostPlatform pkg then pkg else null;

  optPam = shouldUsePkg pam;
  optLibidn = shouldUsePkg libidn;
  optGnutls = shouldUsePkg gnutls;

  inherit (lib) enableFeature withFeature optionalString;
in
stdenv.mkDerivation rec {
  pname = "shishi";
  version = "1.0.2";

  src = fetchurl {
    url = "mirror://gnu/shishi/shishi-${version}.tar.gz";
    sha256 = "032qf72cpjdfffq1yq54gz3ahgqf2ijca4vl31sfabmjzq9q370d";
  };

  separateDebugInfo = true;

  # Fixes support for gcrypt 1.6+
  patches = [
    ./gcrypt-fix.patch
    ./freebsd-unistd.patch
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libgcrypt
    libgpg-error
    libtasn1
    optPam
    optLibidn
    optGnutls
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    (enableFeature true "libgcrypt")
    (enableFeature (optPam != null) "pam")
    (enableFeature true "ipv6")
    (withFeature (optLibidn != null) "stringprep")
    (enableFeature (optGnutls != null) "starttls")
    (enableFeature true "des")
    (enableFeature true "3des")
    (enableFeature true "aes")
    (enableFeature true "md")
    (enableFeature false "null")
    (enableFeature true "arcfour")
  ];

  env.NIX_CFLAGS_COMPILE = optionalString stdenv.hostPlatform.isDarwin "-DBIND_8_COMPAT";

  doCheck = true;

  installFlags = [ "sysconfdir=\${out}/etc" ];

  # Fix *.la files
  postInstall = ''
    sed -i $out/lib/libshi{sa,shi}.la \
  ''
  + optionalString (optLibidn != null) ''
    -e 's,\(-lidn\),-L${optLibidn.out}/lib \1,' \
  ''
  + optionalString (optGnutls != null) ''
    -e 's,\(-lgnutls\),-L${optGnutls.out}/lib \1,' \
  ''
  + ''
    -e 's,\(-lgcrypt\),-L${libgcrypt.out}/lib \1,' \
    -e 's,\(-lgpg-error\),-L${libgpg-error.out}/lib \1,' \
    -e 's,\(-ltasn1\),-L${libtasn1.out}/lib \1,'
  '';

  meta = with lib; {
    homepage = "https://www.gnu.org/software/shishi/";
    description = "Implementation of the Kerberos 5 network security system";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.linux;
  };
}
