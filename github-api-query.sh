#! /usr/bin/env sh

# Sample of the query:
# https://docs.github.com/en/rest/search?apiVersion=2022-11-28#constructing-a-search-query

GH_QUERY='"https%3A%2F%2Fblueoakcouncil.org%2Flicense%2F1.0.0."'
GH_PER_PAGE=100
#TEXT_MATCH=".text-match"
: ${GH_TOKEN:=`read -p "Enter the token (or just export via GH_TOKEN): "; echo $REPLY`}

PATH=$PATH:/mingw64/bin
BUFF="`mktemp`.buffer"


query () {
    query="$1"
    curl -L \
        -H "Accept: application/vnd.github${TEXT_MATCH}+json" \
        -H "Authorization: Bearer ${GH_TOKEN}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/search/code?q=${query}"
}


echo "Created buffer:"
touch ${BUFF}
ls -Alh --color ${BUFF}

while
    PAGE=$((PAGE+1))
    echo "Processing page ${PAGE}"

    query "${GH_QUERY}&per_page=${GH_PER_PAGE}&page=${PAGE}" > ${BUFF}
    cat ${BUFF}
    ITEM_COUNT=`{ jq '.items | length' | sed s/\\r//; } < ${BUFF}`
    RESULTS_COUNT=`{ jq '.total_count' | sed s/\\r//; } < ${BUFF}`
    echo "Results count so far: ${RESULT_COUNT}" >/dev/stderr
    sleep 2

    [ ${ITEM_COUNT} = ${GH_PER_PAGE} ]
do :; done

echo "Removing buffer:"
rm -v ${BUFF}
