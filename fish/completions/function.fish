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
