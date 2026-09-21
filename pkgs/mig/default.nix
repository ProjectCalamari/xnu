{
  lib,
  stdenv,
  darwin,
  bison,
  flex,
}:
let
  xnuSource = lib.cleanSource ../..;
in
stdenv.mkDerivation {
  pname = "mig";
  version = "138";

  src = darwin.bootstrap_cmds.src;

  nativeBuildInputs = [
    bison
    flex
  ];

  postPatch = ''
    substituteInPlace migcom.tproj/lexxer.l \
      --replace-fail 'y.tab.h' 'parser.tab.h'
    substituteInPlace migcom.tproj/mig.sh \
      --replace-fail 'arch=`/usr/bin/arch`' 'arch=`uname -m`' \
      --replace-fail '/usr/bin/mktemp' 'mktemp' \
      --replace-fail '/bin/rmdir' 'rmdir'
    # The build flags select the target.  Do not add the host architecture a
    # second time; upstream clang does not support Apple's -arch option.
    sed -i 's/ -arch ''${arch}//' migcom.tproj/mig.sh
  '';

  buildPhase = ''
    runHook preBuild
    cd migcom.tproj
    bison parser.y --header=parser.tab.h --output=parser.tab.c
    flex --header-file=lexxer.yy.h --outfile=lexxer.yy.c lexxer.l
    $CC -std=gnu17 -DMIG_VERSION='"migcom-138"' -D_GNU_SOURCE \
      -include ${./include}/xnu_mig_compat.h -I. -I${./include} \
      -I${xnuSource}/osfmk \
      -I${xnuSource}/libkern \
      error.c global.c header.c mig.c routine.c server.c statement.c \
      string.c type.c user.c utils.c parser.tab.c lexxer.yy.c \
      -o migcom
    cd ..
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 migcom.tproj/migcom "$out/libexec/migcom"
    install -Dm755 migcom.tproj/mig.sh "$out/bin/mig"
    patchShebangs --build "$out/bin/mig"
    runHook postInstall
  '';
}
