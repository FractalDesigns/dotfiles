install: install-fonts 
  stow --target ~/.config .
  [[ "$OSTYPE" == "darwin"* ]] && stow --target ~/Library/Application\ Support/nushell nushell
  #ln -s ~/.config/git/config ~/.gitconfig

install-tmux-tpm:
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

install-fonts:     
    #!/usr/bin/env nu
    mkdir ~/.local/share/fonts
    let repo_url = "https://github.com/NvChad/starter"
    let target_dir = "~/.local/share/fonts " 
    
    if not ($target_dir | path exists) {
        stow -R --target ~/.local/share/fonts JetBrainsMono/ 
        echo "JetBrainsMono installed linked to ~/.local/share/fonts"
    } else {
        echo "Fonts already linked"
    }

install-lazy-vim:
	cd nvim && stow --target ~/.config/nvim .
uninstall-nvim: 
    rm -rf ~/.config/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.local/share/nvim    

