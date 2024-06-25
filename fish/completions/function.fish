# Function to filter through recently used directories
function zd --argument-names 'name'
  set -l zd_command "command fasd -Rdl $name 2> /dev/null"
  fish -c "$zd_command" | __fzfcmd -1 -0 --no-sort -m | read -la select
  if test ! (count $select) -eq 0
    cd "$select"
  end
end

# Set above function to even shorter j alias
alias j="zd"

function gus
    if test (uname) = "Linux"
        set os (cat /etc/os-release | grep '^NAME=' | cut -d'=' -f2 | tr -d '"')

        switch $os
            case "Ubuntu"
            	if command -sq nala
    		    set pm "nala"
		else
		    set pm "apt"
		end
            case "Debian"
                set pm "apt"
            case "Fedora"
                set pm "dnf"
            case "CentOS Linux"
                set pm "yum"
            case "Arch Linux"
                set pm "pacman"
            case "*"
                echo "Unsupported distribution"
                return
        end
    else
        echo "Not a Linux system"
        return
    end

    set cmd $argv[1]
    set package $argv[2..-1]

    switch $cmd
    	case "i"
    	    echo "Installing $package using $pm"
            sudo $pm install $package
        case "r"
            echo "Removing $package using $pm"
            sudo $pm remove $package
        case "u"
            echo "Updating packages using $pm"
            sudo $pm update
        case "install"
            echo "Installing $package using $pm"
            sudo $pm install $package
        case "remove"
            echo "Removing $package using $pm"
            sudo $pm remove $package
        case "update"
            echo "Updating packages using $pm"
            sudo $pm update
        case "upgrade"
            echo "Upgrading packages using $pm"
            sudo $pm upgrade
        case "search"
            set keyword $package
            echo "Searching for $keyword using $pm"
            sudo $pm search $keyword
        case "*"
	    if test -z $package
	    	sudo $pm $cmd
	    else
	    	sudo $pm $cmd $package
	    end
    end
end

function cd
    if test (count $argv) -gt 0
        builtin cd $argv; and la
    else
        builtin cd; and la
    end
end

