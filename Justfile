install:
  # install nvchad: 
  git clone https://github.com/NvChad/starter ~/.config/nvim
  stow --target ~/.config .
  mkdir -p ~/.local/share/fonts
  stow -R --target ~/.local/share/fonts JetBrainsMono/ 
  ln -s ~/.config/git/config ~/.gitconfig
