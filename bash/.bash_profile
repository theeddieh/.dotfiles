# source .bashrc
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

DOTFILES="${HOME}/.dotfiles"

# PATH
## Add "gnubin" directory to PATH default to newer grep
PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

# SCRIPTS linked into PATH
# ln -s ~${DOTFILES}/bin/appgater.sh /usr/local/bin/apg

# AUTOCOMPLETE
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
# source <(kubectl completion bash)

if [[ -e "/usr/local/share/bash-completion/bash_completion" ]]; then
    export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
    source "/usr/local/share/bash-completion/bash_completion"
elif [[ -e "/usr/local/etc/profile.d/bash_completion.sh" ]]; then
    source "/usr/local/etc/profile.d/bash_completion.sh"
elif [[ -e "/etc/bash_completion" ]]; then
    source "/etc/bash_completion"
fi

## via homebrew
# source /usr/local/etc/bash_completion.d/brew
# source /usr/local/etc/bash_completion.d/npm
# source /usr/local/etc/bash_completion.d/git-completion.bash
# source /usr/local/etc/bash_completion.d/hub.bash_completion.sh
# source /usr/local/etc/bash_completion.d/kubectl

# PROMPT changes
source ${DOTFILES}/bin/battery-status.sh
source ${DOTFILES}/git/git-prompt.sh
export PROMPT_COMMAND='__posh_git_ps1 "[`__battery_status`]  \W " "\n▷  ";'$PROMPT_COMMAND

# ALIASES and FUNCTIONS
for file in $(find ${DOTFILES} -name aliases.sh); do
    source ${file}
done
