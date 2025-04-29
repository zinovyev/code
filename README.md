# My Nvim configuration

## Prerequisites

- nvim (`pacman -S extra/neovim`)
- tree-sitter and tree-sitter-cli (`extra/tree-sitter-cli extra/tree-sitter`)
- patched fonts (`pacman -S extra/otf-droid-nerd`)
- Ruby LSP for ruby (`gem install ruby-lsp`)
- Ripgrep (`pacman -S fzf ripgrep`)
- Install node (there're many installation options, I use `asdf` for that purpose)
  - Export the `COC_NODE` env variable to get the COC use a proper Node version (optional)
- Have viver installed on your system (see https://github.com/zinovyev/viver)
  - Add the following to your `.zshrc` or `.bashrc`: `PATH="$HOME/.config/viver/bin:$PATH"`

## Installation

1. Using Viver's `Install` from remote source install this configuration
   using the git source: https://github.com/zinovyev/code.git
2. Assuming the configuration is called `code`, here's an example command to install vim-plug:
   ```bash
   curl -fLo ~/.config/viver/setups/code/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   ```
3. Assuming, you followed the `Making a Configuration Executable` section from the viver documentation,
   you can now execute the new configuration like `code`
