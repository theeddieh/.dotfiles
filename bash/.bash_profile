# source .bashrc
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# PATH updates

#  git 
## auto complete
source ~/.dotfiles/git/git-completion.bash
## posh-git in prompt
source ~/.dotfiles/git/git-prompt.sh

#scripts
## battery status
source ~/.dotfiles/bin/battery-status.sh

# add git and battery status to promt
export PROMPT_COMMAND='__posh_git_ps1 "[`__battery_status`]  \W " "\n▷  ";'$PROMPT_COMMAND

# aliases
alias bashedit='nano ~/.bash_profile'
alias reload='source ~/.bash_profile'
alias ll='ls -lhaG'
alias lspath='tr : \\'\n\\' <<<$PATH'
alias fancydate='date +"It is %r %Z on %A, %B %d, Anno Domini %Y."'
alias moon='curl wttr.in/moon'
alias weather='curl wttr.in'
