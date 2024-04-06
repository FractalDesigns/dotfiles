install:
  stow --target ~/.config .
  mkdir -p ~/.local/share/fonts
  stow -R --target ~/.local/share/fonts JetBrainsMono/ 
  ln -s ~/.config/git/config ~/.gitconfig
