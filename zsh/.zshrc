
DOTFILES="${HOME}/.dotfiles"

# ln -s "${DOTFILES}/git/config ${HOME}/.gitconfig"

# ALIASES and FUNCTIONS
source ${DOTFILES}/git/aliases.sh
source ${DOTFILES}/ssh/aliases.sh
source ${DOTFILES}/vscode/aliases.sh
source ${DOTFILES}/zsh/aliases.sh

source ${DOTFILES}/bin/battery-status.sh
source ${DOTFILES}/git/git-prompt.sh

# add Visual Studio Code to PATH
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:${PATH}"

# PROMPT changes
export GIT_PS1_SHOWCOLORHINTS=1

precmd () { 
    __git_ps1 "$(__battery_status)" " %~ ▷ " "[%s] "  
}


