# aws-keycloak authentication aliases

# Expects a profile alias to follow, followed by the command.

# They are defined in ~/.aws/keycloak-config
# TODO: dynamically generate/print list of profile aliases
# See these for ideas on better wrapping/integrating keycloak and aws cli tool
# - https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
# - https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sourcing-external.html
# - https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html

# append --debug after the profile name to overwrite --quiet
# usage:
#   cloak <environment> check
#   cloak <environment> --debug -- sops ...
alias cloak='aws-keycloak --quiet --profile'

# usage:
#   sops-set <environment> <SECRET_KEYNAME> <secret>  <path/to/secrets.yaml>
# e.g. cloak ${env} -- sops --set '["deployment"]["secretEnv"]["'${key}'"] "'${secret}'"' ${file}
# value must be a json encoded string. (edit mode only). eg. --set '["somekey"][0] {"somevalue":true}'
# really ought to validate this for creating/updating secrets at multiple levels

sops-set()  {
    env=${1}

    key=${2}
    secret=${3}
    file=${4}

    cloak ${env} -- sops --set '["slack"]["'${key}'"] "'${secret}'"' ${file}
}

# expects to be run in kilonova-envs-config/<env>/
sops-play() {
    env="$(basename ${PWD})"

    cloak ${env} -- sops $*
}

sopup() {
    env="$(basename ${PWD})"
    cloak ${env} -- sops $*
}

sops-get() {
    env="$(basename ${PWD})"

    cloak ${env} -- sops --decrypt --extract $*
}
