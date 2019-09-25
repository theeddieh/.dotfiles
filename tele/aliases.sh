# tele login aliases

telin() {
    env=${1}
    cluster=${2:-2}
    tsh  logout --debug
    tele logout --debug
    tele login  --debug --auth=Keycloak --ops opscenter.${env}.msap.io stable${cluster} \
                                                                         && tsh login --debug
}

telout() {
    tsh  logout --debug
    tele logout --debug
}

alias kbuild='telin kbuild'
alias kbuild-dev='telin kbuild-dev'

alias cpdev='telin cpdev'
alias kdev='telin kdev'
alias kqa='telin kqa'
alias kstg='telin kstg'

alias kprod='telin kprod'
alias kprod-eu='telin kprod-eu'

alias kgbuild='telin gbuild'
alias kgstg='telin kgstg'
alias kgprod='telin kgprod'
