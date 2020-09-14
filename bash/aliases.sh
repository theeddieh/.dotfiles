# misc bash aliases

alias bashedit='nano ~/.bash_profile'
alias reload='source ~/.bash_profile'

alias l='ls -Al -FGho'
alias lt='ls -Al -FGho -rtT'
alias lt-create='ls -Al -FGho -rtT -U'
alias lt-access='ls -Al -FGho -rtT -u'
alias ls-path='tr : \\'\n\\' <<<$PATH'

alias today='date +"%Y/%m/%d"'
alias fancydate='date +"It is %r %Z on %A, %B %d, Anno Domini %Y."'
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
        ${1} ${2} \
        | colordiff
}
