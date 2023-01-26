
DOTFILES="${HOME}/.dotfiles"

# ln -s "${DOTFILES}/git/config ${HOME}/.gitconfig"

# ALIASES
source ${DOTFILES}/git/aliases.sh
source ${DOTFILES}/ssh/aliases.sh
source ${DOTFILES}/vscode/aliases.sh
source ${DOTFILES}/zsh/aliases.sh

# FUNCTIONS
source ${DOTFILES}/bin/battery-status.sh
source ${DOTFILES}/git/posh-git-sh/git-prompt.sh

# load zsh-completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi

# add Visual Studio Code to PATH
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:${PATH}"

# PROMPT changes
precmd () { 
    __posh_git_ps1 "$(__battery_status)" " %~ ▷ "  
}


