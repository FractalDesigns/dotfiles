install: #install-fonts 
  stow --target ~/.config .
  [[ "$OSTYPE" == "darwin"* ]] && stow --target ~/Library/Application\ Support/nushell nushell
  #ln -s ~/.config/git/config ~/.gitconfig

install-tmux-tpm:
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

install-fonts:     
    #!/usr/bin/env nu
    mkdir ~/.local/share/fonts
    # let repo_url = "https://github.com/NvChad/starter"
    let target_dir = $env.HOME + "/.local/share/fonts"
    print $target_dir
    if ($target_dir | path exists) {
        cd fonts 
        stow -R -t $target_dir JetBrainsMono
        echo "JetBrainsMono installed and linked to ~/.local/share/fonts"
        stow -R -t $target_dir VictorMono
        echo "VictorMono installed and linked to ~/.local/share/fonts"
        fc-cache -f ~/.local/share/fonts
        echo "Font cache rebuilt"
    } else {
        echo "unable to install fonts"
    }

install-lazy-vim:
	cd nvim && stow --target ~/.config/nvim .
uninstall-nvim: 
    rm -rf ~/.config/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.local/share/nvim    

