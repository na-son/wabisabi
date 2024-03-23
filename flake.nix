{
  description = "Starter Configuration for MacOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs = { self, nixpkgs, disko }@inputs:
    let
      user = "nason";
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      mkApp = scriptName: system: {
        type = "app";
        program = "${
            (nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
              #!/usr/bin/env bash
              PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
              echo "Running ${scriptName} for ${system}"
              exec ${self}/apps/${system}/${scriptName}
            '')
          }/bin/${scriptName}";
      };
      mkLinuxApps = system: {
        "apply" = mkApp "apply" system;
        "build-switch" = mkApp "build-switch" system;
        "install" = mkApp "install" system;
      };
    in {
      apps = nixpkgs.lib.genAttrs linuxSystems mkLinuxApps;

      # cluster
      nixosConfigurations.peace = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [ disko.nixosModules.disko ./hosts/nixos ];
      };

      #nixosConfigurations.love = nixpkgs.lib.nixosSystem {
      #  system = "aarch64-linux";
      #  specialArgs = inputs;
      #  modules = [ disko.nixosModules.disko ./hosts/nixos ];
      #};



      # "default" config
      #nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (system:
      #  nixpkgs.lib.nixosSystem {
      #    inherit system;
      #    specialArgs = inputs;
      #    modules = [
      #      disko.nixosModules.disko
      #      ./hosts/nixos
      #    ];
      #  });
    };
}
