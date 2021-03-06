{ mkDerivation, stdenv, fetchurl, pkgconfig, qttools, sconsPackages
, GConf, avahi, boost, hunspell, libXScrnSaver, libedit, libidn, libnatpmp, libxml2
, lua, miniupnpc, openssl, qtbase, qtmultimedia, qtsvg, qtwebkit, qtx11extras, zlib
}:

mkDerivation rec {
  pname = "swift-im";
  version = "4.0.2";

  src = fetchurl {
    url = "https://swift.im/downloads/releases/swift-${version}/swift-${version}.tar.gz";
    sha256 = "0w0aiszjd58ynxpacwcgf052zpmbpcym4dhci64vbfgch6wryz0w";
  };

  patches = [ ./qt-5.11.patch ./scons.patch ];

  nativeBuildInputs = [ pkgconfig qttools sconsPackages.scons_3_1_2 ];

  buildInputs = [
    GConf avahi boost hunspell libXScrnSaver libedit libidn libnatpmp libxml2
    lua miniupnpc openssl qtbase qtmultimedia qtsvg qtwebkit qtx11extras zlib
  ];

  propagatedUserEnvPkgs = [ GConf ];

  NIX_CFLAGS_COMPILE = toString [
    "-I${libxml2.dev}/include/libxml2"
    "-I${miniupnpc}/include/miniupnpc"
    "-I${qtwebkit.dev}/include/QtWebKit"
    "-I${qtwebkit.dev}/include/QtWebKitWidgets"
    "-fpermissive"
  ];

  installTargets = [ (placeholder "out") ];
  installFlags = [ "SWIFT_INSTALLDIR=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    homepage = "https://swift.im/";
    description = "Qt XMPP client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
