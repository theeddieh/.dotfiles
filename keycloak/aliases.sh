# aws-keycloak authentication aliases

# Expects a profile alias to follow, followed by the command.

# They are defined in ~/.aws/keycloak-config
# TODO: dynamically generate/print list of profile aliases
# See these for ideas on better wrapping/integrating keycloak and aws cli tool
# - https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
# - https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sourcing-external.html
# - https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html

# append --debug after the profile name to overwrite --quite
# usage:
#   cloak <environment> check
#   cloak <environment> --debug -- sops
alias cloak='aws-keycloak --quiet --profile'
