#!/usr/bin/env bash
#
# usage:
#   ./list_services <namespace>

# Outputs list of services and their verisons in the current cluster
# if no arguement is given, lists all namespaces

namespace=${1+"--namespace ${1}"}

(   
    echo     "NAMESPACE SERVICE VERSION"
    echo     "--------- ------- -------"
    helm ls ${namespace} --output json \
        | jq --slurp '[ .[0].Releases[]
            | .Namespace as $ns
            | .Name as $srv
            | {Namespace: .Namespace,
                Service:  .Name    | ltrimstr($ns+"-"),
                Version:  .Chart   | ltrimstr($srv+"-"),
                Date:     .Updated | strptime("%a %b %d %H:%M:%S %Y") | mktime | strftime("%a/%b/%d/%H:%M:%S/%Y") } ]' \
        | jq --slurp --raw-output '.[][] | [.Namespace, .Service, .Version, .Date] | @tsv'
) | column -t
