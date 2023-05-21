#! /usr/bin/env sh

# Sample of the query:
# https://docs.github.com/en/rest/search?apiVersion=2022-11-28#constructing-a-search-query

PATH=$PATH:/mingw64/bin
PIPE="`mktemp`.fifo"
GH_QUERY='"https%3A%2F%2Fblueoakcouncil.org%2Flicense%2F1.0.0."'
#TEXT_MATCH=".text-match"
: ${GH_TOKEN:=`read -p "Enter the token (or just export via GH_TOKEN): "; echo $REPLY`}

query () {
    query="$1"
    curl -L \
        -H "Accept: application/vnd.github${TEXT_MATCH}+json" \
        -H "Authorization: Bearer ${GH_TOKEN}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/search/code?q=${query}"
}

echo "Creating pipe:"
mkfifo ${PIPE}
ls -Alh --color ${PIPE}

query "${GH_QUERY}&per_page=1" | jq .total_count > ${PIPE} &
read < ${PIPE}
query "${GH_QUERY}&per_page=100"

echo "Removing pipe:"
rm -v ${PIPE}
