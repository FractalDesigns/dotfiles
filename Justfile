install: install-nvchad-custom-config
  stow --target ~/.config .
  #ln -s ~/.config/git/config ~/.gitconfig

install-nvchad: install-fonts
    #!/usr/bin/env nu
    let repo_url = "https://github.com/NvChad/starter"
    let target_dir =  ($env.HOME | path join ".config/nvim") 
    
    if not ($target_dir | path exists) {
        git clone $repo_url $target_dir
        echo "Repository cloned successfully."
    } else {
        echo "nvim already exist in ~/.config"
    }

install-nvchad-custom-config: install-nvchad 
    #!/usr/bin/env nu
    let source_file = ($env.PWD | path join 'nvim/configs/lspconfig.lua')
    let target_file = ($env.HOME | path join '.config/nvim/lua/configs/lspconfig.lua') 
    if ($target_file | path exists) {
       print $target_file
       rm $target_file
    }  
    ln -s $source_file $target_file
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
        stow -R --target ~/.config/nvim nvim/
uninstall-nvchad: 
    rm -rf ~/.config/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.local/share/nvim    

