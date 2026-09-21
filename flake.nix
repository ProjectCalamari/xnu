{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flakever.url = "github:numinit/flakever";
    dtrace = {
      url = "github:ProjectCalamari/dtrace";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
        flakever.follows = "flakever";
      };
    };
    cctools = {
      url = "github:ProjectCalamari/cctools";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
        flakever.follows = "flakever";
      };
    };
    llvm = {
      url = "github:ProjectCalamari/llvm-project/calamari/lld-macho-static-layout";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      flakever,
      dtrace,
      cctools,
      llvm,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "riscv64-linux"
      ];

      flakeverConfig = flakever.lib.mkFlakever {
        inherit inputs;

        digits = [
          1
          2
          2
        ];
      };

      forAllSystems =
        f:
        genAttrs allSystems (
          system:
          f {
            inherit system;
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                dtrace.overlays.default
                cctools.overlays.default
                self.overlays.default
              ];
            };
          }
        );

      treefmtEval = forAllSystems ({ pkgs, ... }: treefmt-nix.lib.evalModule pkgs (import ./treefmt.nix));
    in
    {
      versionTemplate = "12377.1.9-<lastModifiedDate>-<rev>";

      overlays.default = final: prev: {
        llvmPackages_calamari =
          (final.mkLLVMPackages {
            gitRelease = {
              rev-version = "24.0.0-unstable-2026-09-20";
            };
            version = "24.0.0";
            monorepoSrc = llvm // {
              passthru = { };
            };
            name = "calamari";
          }).value;
        xnu = final.callPackage ./pkgs/xnu {
          flakever = flakeverConfig;
          ctfconvert =
            if builtins.hasAttr "ctfconvert" final then
              final.ctfconvert
            else
              dtrace.packages.${final.stdenv.hostPlatform.system}.ctfconvert;
          cctools =
            if builtins.hasAttr "cctools" final then
              final.cctools
            else
              cctools.packages.${final.stdenv.hostPlatform.system}.cctools;
          llvmPackages = final.llvmPackages_calamari;
        };
      };

      legacyPackages = forAllSystems ({ pkgs, ... }: pkgs);

      devShells = forAllSystems (
        { pkgs, ... }:
        {
          default = pkgs.xnu.shell;
        }
      );

      packages = forAllSystems (
        { pkgs, ... }:
        {
          default = pkgs.xnu;
        }
      );

      formatter = forAllSystems ({ system, ... }: treefmtEval.${system}.config.build.wrapper);

      checks = forAllSystems (
        { system, pkgs, ... }:
        {
          inherit (pkgs) xnu;
          formatting = treefmtEval.${system}.config.build.check self;
        }
      );
    };
}
