function fasd_cd -d "fasd builtin cd"
  if test (count $argv) -le 1
    command fasd "$argv"
  else
    fasd -e 'printf %s' $argv | read -l ret
    test -z "$ret"; and return
    test -d "$ret"; and cd "$ret"; or printf "%s\n" $ret
  end
end

function mkcd
    switch "$argv[1]"
        case '*/..|*/../'
            cd -- "$argv[1]"
        case '/*/../*'
            set dir (dirname "$argv[1]")/../
            mkdir -p "$dir"; cd "$dir"
        case '/*'
            mkdir -p "$argv[1]"; cd "$argv[1]"
        case '*/../*'
            set dir (dirname "$argv[1]")/../
            mkdir -p "$dir"; cd "$dir( basename "$argv[1]" | sed 's#^\.\./##' )"
        case '../*'
            mkdir -p (dirname "$argv[1]")/../; cd (dirname "$argv[1]")/../; mkdir -p (basename "$argv[1]" | sed 's#^\.##'); cd "$argv[1]"
        case '*'
            mkdir -p "$argv[1]"; cd "$argv[1]"
    end
end


alias md=mkcd
