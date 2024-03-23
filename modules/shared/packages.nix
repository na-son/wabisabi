{ pkgs }:

with pkgs; [
  # General packages for development and system management
  #aspell
  #aspellDicts.en
  bash-completion
  bat
  coreutils
  #neovim
  openssh
  wget
  zip

  # Cloud-related tools and SDKs
  #docker
  #docker-compose
  #awscli
  #google-cloud-sdk

  # Text and terminal utilities
  htop
  iftop

  # Python
  #python39
  #python39Packages.virtualenv # globally install virtualenv
  #ansible
  #ansible-lint

]
