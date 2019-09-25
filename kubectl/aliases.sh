#Pods handling

# alias deletePod='kubectl delete pod $1 -n <namespace>'
# alias describePod='kubectl -n <namespace> describe pod $1'
# alias getLog='kubectl --namespace <namespace> logs -f $1'
# alias findbackup='kubectl --namespace <namespace> get pods -a | grep backup'
# alias getjobs='kubectl --namespace <namespace> get jobs'
# alias getpods='kubectl --namespace <namespace> get pods'
# alias logInPod='kubectl --namespace <namespace> exec -ti "$1" bash'
# alias editDeploy='kubectl -n <namespace> edit deploy <namespace>-projects'

k-pods() {
    ns="--namespace ${1}"
    if [[ -z "${1}" ]]; then
        ns="--all-namespaces"
    fi
    kubectl get pods ${ns}
}

# describepod() {
#     kubectl --namespace <namespace> describe pod "$1"
# }

# getLog() {
#     kubectl --namespace <namespace> logs -f "$1"
# }

# logInPod() {
#     kubectl --namespace <namespace> exec -ti "$1" bash
# }

# forwardPort() {
#     echo "kubectl -n <namespace> port-forward service/projects-service 8888:80"
#     kubectl -n <namespace> port-forward service/projects-service 8888:80
# }

# #Chart fields
# kubectl explain --recursive cronjob | less

# #Chart usage
# getManifest() {
#     helm get manifest $1
# }
# helmDelete() {
#     helm delete --purge $1
# }
# alias helmls='helm ls' # lists all charts
