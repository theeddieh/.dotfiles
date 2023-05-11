alias reload='source ~/.zshrc'
alias zshedit='nano ~/.zshrc'

alias l='ls  -Al -FGh'
alias ll='ls -al -FGh -o'

alias lt='l -t -rT'

alias lt-created='l -U'
alias lt-access='l -u'
alias lt-modified='l -t'

alias ls-path='tr : \\'\n\\' <<<$PATH'

alias today='date +"%Y/%m/%d"'
alias fancydate='date +"It is %r %Z on %A, %B %d, Anno Domini %Y."'

alias unix-timestamp='date "+%s"'
alias timestamp='date +"%Y%m%d_%H%M%S"'

alias moon='curl wttr.in/moon'
alias weather='curl wttr.in'

alias bless-you='say --voice Anna gesundheit'

# Simple default diff
diffault() {
    diff --ignore-all-space \
        --minimal \
        --side-by-side \
        --width=180 \
        ${1} ${2} |
        colordiff
}
