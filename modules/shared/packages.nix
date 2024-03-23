{ pkgs }:

with pkgs; [
  # General packages for development and system management
  bash-completion
  bat
  coreutils
  openssh
  wget
  zip
  unzip

  # Cloud-related tools and SDKs
  #docker
  #docker-compose
  #awscli
  #google-cloud-sdk

  # Text and terminal utilities
  htop
  iftop
  vim

  # Python
  #python39
  #python39Packages.virtualenv # globally install virtualenv
  #ansible
  #ansible-lint
]
