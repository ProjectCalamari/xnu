{
  lib,
  stdenv,
  flakever,
  mkShell,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xnu";
  inherit (flakever) version;

  src = lib.cleanSource ../../.;

  passthru.shell = mkShell {
    name = "xnu-dev-shell";
  };
})
