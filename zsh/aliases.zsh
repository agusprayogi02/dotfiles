# ALIASES

alias c="coding $HOME/Code"

alias v="nvim"
alias vim="nvim"
alias n="npm"
alias r="ranger"
alias cls="clear"
alias tlf="sudo tail -f"

alias pls=please
alias pn=pnpm

alias mk=make
alias mkc="make clean"
alias mkr="make run"
alias mkt="make test"

# terminal rickroll 🕺💃
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'
alias t="touch"

alias v=vim
alias vi=vim

alias c="code"
alias c.="code ."
alias cr="code -r"
alias cr.="code -r ."

alias r=ranger-cd
alias vm="vifm ."

alias ru=ruby
alias n="node"

alias python="python3"
alias p="python3"
alias pip="pip3"
alias pi="pip3"
alias ve="virtualenv"

# Changing "ls" to "exa"
# alias l='exa --color=always --group-directories-first'      # some files and dirs
# alias la='exa -a --color=always --group-directories-first'  # all files and dirs
# alias ll='exa -1 --color=always --group-directories-first'  # long format
# alias ls='exa -a1 --color=always --group-directories-first' # my preferred listing

# Changing "ls" to "lsd"
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias lsize='du -sh * | sort -h' # show size of current folder
alias ls.='du -sh .'
alias lsizea='du -ah .' # show size of all files and folders


alias cp="cp -i" # confirm before overwriting something
alias df='df -h' # human-readable sizes
alias grep='grep --colour=auto'

alias pg="echo 'Pinging Google' && ping www.google.com"

alias vz="vim ~/.zshrc"
alias vza="vim ~/dotfiles/zsh/aliases.zsh"
alias vza.="vim ~/dotfiles/zsh/.aliases"
alias vzp="vim ~/dotfiles/zsh/plugins.zsh"
alias vzf="vim ~/dotfiles/zsh/functions.zsh"
alias vn="vim ~/.config/nvim/init.vim"
alias vr="vim ~/.config/ranger/rc.conf"

alias ni="npm install"
alias nid="npm install -D"
alias nst="npm run start -s --"
alias ns="npm run server -s --"
alias nb="npm run build -s --"
alias nf="npm fund -s --"
alias nd="npm run dev -s --"
alias nt="npm run test -s --"
alias ntw="npm run test:watch -s --"
alias nv="npm run validate -s --"
alias na="npm audit"
alias naf="npm audit fix"
alias nr="rm -rf node_modules"
alias flush="rm -rf node_modules && npm i && say NPM is done"
alias nicache="npm install --prefer-offline"
alias nioff="npm install --offline"

alias d='ddgr'
alias wi="wikit"
alias lc="lolcat"
alias iu="imgur-uploader"

# Easier directory navigation.
alias ~="cd ~"
alias .="cd .."
alias ..="cd ../.."
alias ...="cd ../../.."
alias ....="cd ../../../.."

# Docker
alias d="docker"
alias dr="docker run"
alias drrm="docker run --rm"
alias drit="docker run -it"
alias dritrm="docker run -it --rm"
alias dritirm="docker run -it --init --rm"
alias dritrmn="docker run -it --rm --name"
alias dc="docker container"
alias ds="docker start"
alias dl="docker logs"
alias dsa="docker start -a"
alias dps="docker ps"
alias dpsa="docker ps --all"
alias dst="docker stop"
alias dk="docker kill"
alias dsp="docker system prune"
alias deit="docker exec -it"
alias db="docker build"
alias dcc="docker commit -c"
alias de="docker exec" 
alias dbt="docker build --tag" 
alias dcp="docker container prune"
alias dils="docker image ls"

# Git
alias git="hub"
alias gs="git status"
alias agi="add-gitignore"
alias lg="lazygit"

# Heroku
alias gphm="git push heroku master"

# Yarn
alias ys="yarn server"
alias yrw="yarn run watch"
alias yri="yarn install"
alias yrs="yarn start"
alias yra="yarn add"

# Scrot
alias s="scrot"

# Youtube DL
alias ydl="youtube-dl"
alias ydlb="youtube-dl -f bestvideo+bestaudio"
alias ydlbd="youtube-dl -f bestvideo+bestaudio -ci --batch-file=download.txt"
alias ydd="youtube-dl -f bestvideo+bestaudio -ci --batch-file=download.txt"
alias ydla="youtube-dl -cio '0%(autonumber)s %(title)s.%(ext)s' -f bestvideo+bestaudio -ci --batch-file=download.txt ; rename 's/000//g' *"
alias ydlas="youtube-dl -cio '0%(autonumber)s %(title)s.%(ext)s' -f bestvideo+bestaudio -ci --write-auto-sub --batch-file=download.txt ; rename 's/000//g' *"

alias pg="sudo -i -u postgres"
alias createdb="sudo -i -u postgres createdb"
alias dropdb="sudo -i -u postgres dropdb"
alias psql="sudo -i -u postgres psql"

alias todo="vim ~/.todo.txt"
alias project="vim ~/.project.txt"
alias notes="vim ~/.notes.txt"

alias tb="taskbook"

# https://medium.com/better-programming/persistent-databases-using-dockers-volumes-and-mongodb-9ac284c25b39
alias mongo="docker run --name mongodb -v mongo-data:/data/mongodb -d -p 27017:27017 -e MONGODB_ROOT_PASSWORD=admin123 bitnami/mongodb; dc start mongodb"
alias redis-docker="docker run --name redisdb -v /data/redisdb -d -p 6379:6379 redis; dc start redisdb"
alias mysql-docker="mkdir /var/lib/mysql; sudo docker run --name mysql-docker -e MYSQL_ROOT_PASSWORD=admin123 -v /var/lib/mysql:/var/lib/mysql -d -p 3306:6603 mysql; dc start mysql-docker"
alias sql-server-docker="docker run -e 'ACCEPT_EULA=Y' -e 'MSSQL_SA_PASSWORD=Akubisa-1' \
   -p 1433:1433 --name sqlServer1 --hostname sqlServer1 \
   -v sqlServer:/data -d\
   mcr.microsoft.com/mssql/server:2022-latest"

alias lst="lite-server"

# no-internet
alias no-internet="sudo -g no-internet"
alias noi="sudo -g no-internet"

# open spotify with no internet
alias s="sudo -g no-internet spotify"

# Xampp
alias xampp="sudo lampp start"
alias lstart="sudo lampp start"
alias lstatus="sudo lampp status"
alias lsql="sudo lampp startmysql"

alias fcam="$FakeCam && p fake.py -c ./config-example.ini"

# Alias Apt
alias aptins="sudo apt-get install"
alias aptup="sudo apt-get update"
alias apt="sudo nala"

alias cekStatus="curl -s -o /dev/null -w '%{http_code}'"

# Aliases for java

# Aliases for Composer
alias composer81="php8.1 $(which composer)"
alias composer80="php8.0 $(which composer)"
alias composer74="php7.4 $(which composer)"
alias ars="php artisan"

# SSH
alias my-ssh="ssh-add ~/.ssh/gh_private && cls"
