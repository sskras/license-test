#! /usr/bin/env sh

# Sample of the query:
# https://docs.github.com/en/rest/search?apiVersion=2022-11-28#constructing-a-search-query

curl -L \
    -H "Accept: application/vnd.github.text-match+json" \
    -H "Authorization: Bearer ****************************************" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/search/code?q=Q
