# source .bashrc
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# go environment variables
export GOROOT="/usr/local/Cellar/go/1.12/libexec"
export GOPATH="/Users/eddie/workarea/build"
export GOBIN="/Users/eddie/workarea/build/bin"

# PATH updates
export PATH=$PATH:$GOBIN:/Users/eddie/Library/Python/2.7/bin

# git auto-complete
source ~/workarea/git-completion.bash

# display posh-git and battery status in prompt
source ~/workarea/git-prompt.sh
source ~/workarea/battery-status.sh
export PROMPT_COMMAND='__posh_git_ps1 "[`__battery_status`]  \W " "\n▷  ";'$PROMPT_COMMAND

# aliases
alias bashedit='nano ~/.bash_profile'
alias reload='source ~/.bash_profile'
alias ll='ls -lhaG'
alias lspath='tr : \\'\n\\' <<<$PATH'
alias fancydate='date +"It is %r %Z on %A, %B %d, Anno Domini %Y."'
alias moon='curl wttr.in/moon'
alias weather='curl wttr.in'
