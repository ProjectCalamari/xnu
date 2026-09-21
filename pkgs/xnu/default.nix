{
  lib,
  stdenv,
  buildPackages,
  flakever,
  mkShell,
  bison,
  flex,
  m4,
  perl,
  python3,
  tcsh,
  unifdef,
  xcbuild,
  ctfconvert,
  cctools,
  llvmPackages,
}:
let
  mig = buildPackages.callPackage ../mig { };
  iig-tools = buildPackages.callPackage ../iig-tools { };
  compilerRtSource = buildPackages.llvmPackages.compiler-rt.src;
  xcbuild' = xcbuild.overrideAttrs (old: {
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-include stdint.h")
    ];
  });
in
stdenv.mkDerivation (
  finalAttrs:
  let
    ctfconvert' = ctfconvert.override {
      xnu = finalAttrs.src;
    };

    cctools' = cctools.override {
      xnu = finalAttrs.src;
    };
  in
  {
    pname = "xnu";
    inherit (flakever) version;

    src = lib.cleanSource ../../.;

    nativeBuildInputs = [
      bison
      flex
      iig-tools
      llvmPackages.lld
      llvmPackages.llvm
      m4
      mig
      perl
      python3
      tcsh
      unifdef
      xcbuild'
      ctfconvert'
      cctools'
    ];

    makeFlags = [
      "CC=${llvmPackages.clang-unwrapped}/bin/clang"
      "CXX=${llvmPackages.clang-unwrapped}/bin/clang++"
      "HOST_CC=${stdenv.cc}/bin/cc"
      "HOST_CXX=${stdenv.cc}/bin/c++"
      "COMPILER_RT_PROFILE_SOURCE=${compilerRtSource}/compiler-rt"
      "DSYMUTIL=${llvmPackages.llvm}/bin/dsymutil"
      "ARCH_CONFIGS=ARM64"
      "KERNEL_CONFIGS=RELEASE"
      "MACHINE_CONFIGS=QEMU"
    ];

    postPatch = ''
      patchShebangs .
    '';

    dontConfigure = true;
    dontStrip = true;
    enableParallelBuilding = true;

    installPhase = ''
      runHook preInstall

      kernelDir=BUILD/obj/RELEASE_ARM64_QEMU
      install -Dm755 "$kernelDir/kernel.release.qemu" \
        "$out/boot/kernel.release.qemu"
      install -Dm755 "$kernelDir/kernel.release.qemu.unstripped" \
        "$out/lib/debug/kernel.release.qemu.unstripped"
      mkdir -p "$out/lib/debug"
      cp -R "$kernelDir/kernel.release.qemu.dSYM" "$out/lib/debug/"

      runHook postInstall
    '';

    passthru.shell = mkShell {
      name = "xnu-dev-shell";
      shellHook = ''
        export CC="${llvmPackages.clang-unwrapped}/bin/clang"
        export CXX="${llvmPackages.clang-unwrapped}/bin/clang++"
        export HOST_CC=cc
        export HOST_CXX=c++
        export COMPILER_RT_PROFILE_SOURCE="${compilerRtSource}/compiler-rt"
        export DSYMUTIL="${llvmPackages.llvm}/bin/dsymutil"
      '';
      packages = [
        bison
        flex
        iig-tools
        llvmPackages.lld
        llvmPackages.llvm
        m4
        mig
        perl
        python3
        tcsh
        unifdef
        xcbuild'
        ctfconvert'
        cctools'
      ];
    };
  }
)
