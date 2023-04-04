{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.disko.url = github:nix-community/disko;
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, disko, ... }@attrs: {
    nixosConfigurations.hetzner-cloud = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ({modulesPath, ... }: {
          imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            (modulesPath + "/profiles/qemu-guest.nix")
            disko.nixosModules.disko
          ];
          disko.devices = import ./disk-config.nix {
            lib = nixpkgs.lib;
          };
          boot.loader.grub = {
            devices = [ "/dev/sda" ];
            efiSupport = true;
            efiInstallAsRemovable = true;
          };
          services.openssh.enable = true;

          users.users.root.openssh.authorizedKeys.keys = [
            # change this to your ssh key
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvLOptRXuOhvUcwN/zhzVThWgGZ1d4QIQmmSy48H9TIhNqpCwHczL982F2emCO0gwG1+onfLZ8lEzIdo//QNnj9jTy0aSvAd2CjQEXDOgH8uIxWOIX8hT8mZ+xVkrNXLxN/5/+MxyOLWAlLpWBgfZPVr+G/j2JZ7Epbkj529lqsYeYen62koGF01YU+sZ/iaWCeJXSlSKGl3orOGSSLBj5wiwKAQFzlTNEJvt8MrVVJe1zUMyL6/RK8H+vZPzAslCVcXgiwYNT6Z0XNTQyHNh6Y1Sp94rt3XGyeh4A2117lEkaB+HTQDd2kjDP0Y0Evee2qkfiPcBLuoXyY2KY5YbxfFncYvlnYcTAL0ycMyhyVl6K5915Gpz+Fc1fuf8lUjusm4hunjiO+sHicOKeCA+1d2cObXPu3Zm1tliexvPuMPvc6uEeJ/RL45J1EdEMdYVOhG03dO1Eh4sjf49jSrBiEdzt0t4XjyKD6AUro1DeHCaGm1+WRdQbI+YO8+1wsu8= root@tailscale-kafka-local-b1"
          ];
        })
      ];
    };
  };
}
