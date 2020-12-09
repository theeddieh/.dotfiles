#!/usr/bin/env bash

# Query a github organization for team's whose name matches a pattern
# Usage:
# $ ./graph-ql-example.sh <org> <name>
#
# e.g.
# $ ./graph-ql-example.sh mulesoft team-

if [ -z "$GITHUB_TOKEN" ]; then
    echo "GITHUB_TOKEN env var is not set"
    exit 1
fi

org=${1}
pattern=${2}

(   
    curl --silent --fail --show-error \
        --url https://api.github.com/graphql \
        -H "Authorization: bearer ${GITHUB_TOKEN}" \
        -X POST \
        -d @- << EOF
{
  "query": "query {
    organization(login:\"${org}\") {
      teams(first:10, query:\"${pattern}\") {
        edges {
          node {
            slug
          }
        }
      }
    }
  }"
}
EOF
) \
    | jq --raw-output '.data.organization.teams.edges[] | .node.slug' \
    | sort
