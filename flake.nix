{
  description = "Vim front-end for the email client Himalaya CLI";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
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
          plugin = name:
            builtins.trace "${name} rev: ${pkgs.vimPlugins.${name}.src.rev}" pkgs.vimPlugins.${name};
          plugins = map plugin;
          customRC = ''
            syntax on
            filetype plugin on

            packadd! himalaya

            " native, fzf or telescope
            let g:himalaya_executable = '/nix/store/w21m119i0ild3wlb4i72s9xdqdcrj4hz-user-environment/bin/himalaya'
            let g:himalaya_config_path = '/home/soywod/.himalaya.config.toml'
            let g:himalaya_folder_picker = 'telescope'
            let g:himalaya_folder_picker_telescope_preview = v:false
            let g:himalaya_complete_contact_cmd = 'echo test@localhost'
          '';
        in
        rec {
          # nix build
          packages.default = pkgs.vimUtils.buildVimPluginFrom2Nix {
            name = "himalaya";
            namePrefix = "";
            src = self;
            # buildInputs = with pkgs; [ himalaya ];
            # postPatch = with pkgs; ''
            #   substituteInPlace plugin/himalaya.vim \
            #     --replace "default_executable = 'himalaya'" "default_executable = '${himalaya}/bin/himalaya'"
            # '';
          };

          # nix develop
          devShell = pkgs.mkShell {
            buildInputs = self.packages.${system}.default.buildInputs;
            nativeBuildInputs = with pkgs; [

              # Nix LSP + formatter
              rnix-lsp
              nixpkgs-fmt

              # Vim LSP
              nodejs
              nodePackages.vim-language-server

              # Lua LSP
              lua52Packages.lua-lsp

              # FZF
              fzf

              # Editors
              ((vim_configurable.override { }).customize {
                name = "vim";
                vimrcConfig = {
                  inherit customRC;
                  packages.myplugins = {
                    start = with pkgs.vimPlugins; [ fzf-vim ];
                    opt = [ self.packages.${system}.default ];
                  };
                };
              })
              (neovim.override {
                configure = {
                  inherit customRC;
                  packages.myPlugins = {
                    start = plugins [ "telescope-nvim" "fzf-vim" ];
                    opt = [ self.packages.${system}.default ];
                  };
                };
              })
            ];
          };
        });
}
