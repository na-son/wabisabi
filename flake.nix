{
  description = "Starter Configuration for MacOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, disko, nixos-generators }@inputs:
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
        "build-switch" = mkApp "build-switch" system;
        "install" = mkApp "install" system;
      };
    in {
      apps = nixpkgs.lib.genAttrs linuxSystems mkLinuxApps;

      nixosConfigurations.peace = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [ disko.nixosModules.disko ./hosts/nixos ];
      };

      #packages.x86_64-linux = {
      #  #vmware = nixos-generators.nixosGenerate {
      #  #  system = "x86_64-linux";
      #  #  #modules = [ ./hosts/nixos ];
      #  #  format = "vmware";
      #  #};

      #   = nixos-generators.nixosGenerate {
      #    system = "x86_64-linux";
      #    format = "raw-efi";
      #  };
      #};

      nixosConfigurations.love = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = inputs;
        modules = [ disko.nixosModules.disko ./hosts/nixos ];
      };

    };
}
