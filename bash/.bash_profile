# source .bashrc
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

DOTFILES="${HOME}/.dotfiles"

# PATH
# PATH="/usr/local/opt/ruby/bin:$PATH"
# PATH="/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"
# PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
# PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

# SCRIPTS linked into PATH
# ln -sf ${DOTFILES}/bin/appgater.sh   /usr/local/bin/apg
# ln -sf ${DOTFILES}/bin/new-script.sh /usr/local/bin/tmpl.sh
# ln -sf ${DOTFILES}/helm/helm_list.sh /usr/local/bin/helm-ls

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

# eval "$(pyenv init -)"

export GITHUB_TOKEN=$(grep password ~/.netrc | cut -d' ' -f 2)
export MULETEER_TOKEN=$(grep token ~/.muleteer | cut -d' ' -f 2)
export EDITOR=nano

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
