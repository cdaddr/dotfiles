function vim --wraps=nvim --description 'alias vim=nvim'
    nvim $argv;
end

function ev --wraps=vim --description 'edit vim config'
    nvim ~/.config/nvim/init.vim
end

function ef --wraps=vim --description 'edit fish config'
    nvim ~/.config/fish/config.fish
end

function ek --wraps=vim --description 'edit kitty config'
    nvim ~/.config/kitty/kitty.conf
end

