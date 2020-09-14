# tele login aliases

telin() {
    env=${1}

    if [[ "${2}" == "ops" ]] || [[ "${2}" == "hub" ]]; then
        cluster="opscenter"
    else
        cluster="${2}"
    fi

    telout ${tele_cmd}

    tele login \
        --debug \
        --auth Keycloak \
        --hub opscenter.${env}.msap.io \
        ${cluster}

    tsh login \
        --debug \
        --proxy opscenter.${env}.msap.io
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

alias tele-env='tele status | grep "opscenter.[a-z-]*.msap.io" --only-matching | cut -d "." -f 2'
alias tele-cluster='tele status | grep "Cluster" | cut -f 2'
