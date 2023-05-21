#! /usr/bin/env sh

# Sample of the query:
# https://docs.github.com/en/rest/search?apiVersion=2022-11-28#constructing-a-search-query

GH_QUERY="q=Q"
#TEXT_MATCH=".text-match"
: ${GH_TOKEN:=`read -p "Enter the token (or just export via GH_TOKEN): "; echo $REPLY`}

curl -L \
    -H "Accept: application/vnd.github${TEXT_MATCH}+json" \
    -H "Authorization: Bearer ${GH_TOKEN}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/search/code?${GH_QUERY}
