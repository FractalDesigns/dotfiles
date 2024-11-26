install: install-nvchad
  stow --target ~/.config .
  #ln -s ~/.config/git/config ~/.gitconfig

install-nvchad: install-fonts
    #!/usr/bin/env nu
    let repo_url = "https://github.com/NvChad/starter"
    let target_dir = "~/.config" 
    
    if not ($target_dir | path exists) {
        git clone $repo_url $target_dir
        echo "Repository cloned successfully."
    } else {
        echo "nvim already exist in ~/.config"
    }

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
