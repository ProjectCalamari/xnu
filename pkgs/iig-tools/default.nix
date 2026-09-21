{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "iig-tools";
  version = "0.1-unstable-2026-09-17";

  src = fetchFromGitHub {
    owner = "PureDarwin";
    repo = "iig-tools";
    rev = "28010c688caab7eb5400b9c98faa5b1e538e0108";
    hash = "sha256-MFc/y46GA3eolVC68nQT+2i8WGZ7R9/Ra3ux3lNJUEo=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "IOKit Interface Generator for DriverKit interfaces";
    homepage = "https://github.com/PureDarwin/iig-tools";
    license = lib.licenses.asl20;
    mainProgram = "iig";
    platforms = lib.platforms.unix;
  };
}
