install:
  stow --target ~/.config .
  mkdir -p ~/.local/share/fonts
  stow --target ~/.local/share/fonts JetBrainsMono/
  ln -s ~/.config/git/config ~/.gitconfig
