unlet b:current_syntax
syntax include @toml syntax/toml.vim
syntax region tomlFrontmatter start=/\%^+++$/ end=/^+/ keepend contains=@toml

unlet b:current_syntax
syntax include @yaml syntax/yaml.vim
syntax region yamlFrontmatter start=/\%^---$/ end=/^\%$/ keepend contains=@yaml
