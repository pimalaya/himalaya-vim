{
  description = "Vim front-end for the email client Himalaya CLI";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.11";
    };
    utils = {
      url = "github:numtide/flake-utils";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
          plugin = pkgs.vimUtils.buildVimPlugin {
            pname = "himalaya";
            version = "2.0.0";
            src = self;
          };
          vim = pkgs.vim-full.customize {
            name = "vim";
            vimrcConfig = {
              customRC = ''
                syntax on
                filetype plugin on
                packadd! himalaya
              '';
              packages.myplugins = {
                start = with pkgs.vimPlugins; [ fzf-vim ];
                opt = [ plugin ];
              };
            };
          };
        in
        {
          # nix build
          packages.default = plugin;

          # nix flake check
          checks.default = pkgs.runCommand "himalaya-vim-tests" { nativeBuildInputs = [ pkgs.vim ]; } ''
            cp -r ${self} src && chmod -R u+w src && cd src
            patchShebangs tests/bin
            vim -Nu NONE -i NONE -es -S tests/run.vim </dev/null
            touch $out
          '';

          # nix develop
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              nixpkgs-fmt
              nodePackages.vim-language-server
              fzf
              vim
            ];
          };
        });
}
