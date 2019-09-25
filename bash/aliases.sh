# misc bash aliases

alias bashedit='nano ~/.bash_profile'
alias reload='source ~/.bash_profile'

alias l='ls -Al -FGhoO'
alias ls-cre='ls -Al -FGhoO -rtT -U'
alias ls-acc='ls -Al -FGhoO -rtT -u'
alias ls-mod='ls -Al -FGhoO -rtT'
alias ls-path='tr : \\'\n\\' <<<$PATH'

alias today='date +"%Y/%m/%d"'
alias fancydate='date +"It is %r %Z on %A, %B %d, Anno Domini %Y."'
alias timestamp='date +"%Y%m%d_%H%M%S"'

alias moon='curl wttr.in/moon'
alias weather='curl wttr.in'

# Simple default diff
diffault() {
    diff --ignore-all-space \
        --minimal \
        --side-by-side \
        --width=180 \
        ${1} ${2} \
        | colordiff
}
