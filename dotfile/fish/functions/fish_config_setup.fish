function fish_config_setup
    curl -sL https://git.io/fisher | source

    fisher install jorgebucaran/fisher
    fisher install patrickf1/fzf.fish
    fisher install jorgebucaran/nvm.fish
    fisher install jorgebucaran/autopair.fish
    fisher install jorgebucaran/hydro
end
