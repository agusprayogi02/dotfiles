# fnm
set PATH "/home/agus/.local/share/fnm" $PATH
fnm env | source

# fnm
set FNM_PATH "/home/agus/.local/share/fnm"
if [ -d "$FNM_PATH" ]
  set PATH "$FNM_PATH" $PATH
  fnm env | source
end

# fnm
set FNM_PATH "/home/agus/.local/share/fnm"
if [ -d "$FNM_PATH" ]
  set PATH "$FNM_PATH" $PATH
  fnm env | source
end
