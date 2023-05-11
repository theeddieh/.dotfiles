# source .bashrc
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

DOTFILES="${HOME}/.dotfiles"

# PATH stuff

PATH="$PATH:/usr/local/go/bin"
PATH="$PATH:/usr/local/share/dotnet"
PATH="$PATH:/opt/X11/bin"

PATH="$PATH:/usr/local/opt/grep/libexec/gnubin"
PATH="$PATH:/usr/local/opt/gnu-sed/libexec/gnubin"

PATH="$PATH:/usr/local/opt/ruby/bin"
PATH="$PATH:/usr/local/lib/ruby/gems/2.7.0/bin"

PATH="$PATH:/usr/local/bin"
PATH="$PATH:/usr/bin"
PATH="$PATH:/bin"
PATH="$PATH:/usr/sbin"
PATH="$PATH:/sbin"

# AUTOCOMPLETE
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# PYTHON
# eval "$(pyenv init -)"

# GITHUB
# export GITHUB_TOKEN=$(grep password ~/.netrc | cut -d' ' -f 2)

export EDITOR=nano

# PROMPT CUSTOMIZATIONS
# e.g. [🔋  3:01 ]  ~  [master +2 ~4 -0]
source ${DOTFILES}/bin/battery-status.sh
source ${DOTFILES}/git/git-prompt.sh
export PROMPT_COMMAND='__posh_git_ps1 "[`__battery_status`]  \W " "\n▷  ";'$PROMPT_COMMAND

# ALL ALIASES and FUNCTIONS
for file in $(find ${DOTFILES} -name aliases.sh); do
    source ${file}
done
