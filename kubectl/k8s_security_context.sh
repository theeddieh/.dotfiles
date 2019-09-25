#!/usr/bin/env bash
#
# usage:
#   ./kube-pod-security-context.sh --namespace core-paas
#
# References:
#   - https://github.com/novas0x2a/config-files/blob/master/bin/kpodsecurity
#   - https://goessner.net/articles/JsonPath/
#

set -euo pipefail

ARGS=("${@:---all-namespaces}")

(   
    echo "NAMESPACE NAME PSP POD-SECURITY INIT-CONTAINER-SECURITY CONTAINER-SECURITY"
    kubectl get pods "${ARGS[@]}" -o json \
        | jq -r '.items[] 
            | {namespace: .metadata.namespace, 
                name: .metadata.name, 
                psp: .metadata.annotations["kubernetes.io/psp"], 
                podSecurity: .spec.securityContext, 
                initContainerSecurity: (.spec.initContainers // []) | map(.securityContext), 
                containerSecurity: (.spec.containers // []) | map(.securityContext)} 
            | "\(.namespace) \(.name) \(.psp) \(.podSecurity) \(.initContainerSecurity) \(.containerSecurity)"'
) | column -t
