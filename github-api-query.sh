#! /usr/bin/env sh

# Sample of the query:
# https://docs.github.com/en/rest/search?apiVersion=2022-11-28#constructing-a-search-query

GH_QUERY='"https%3A%2F%2Fblueoakcouncil.org%2Flicense%2F1.0.0."'
GH_PER_PAGE=100
#TEXT_MATCH=".text-match"
: ${GH_TOKEN:=`read -p "Enter the token (or just export via GH_TOKEN): "; echo $REPLY`}

BUFF="`mktemp`.buffer"
CONC="`mktemp`.concat"
PATH=$PATH:/mingw64/bin


query () {
    query="$1"
    curl -L \
        -H "Accept: application/vnd.github${TEXT_MATCH}+json" \
        -H "Authorization: Bearer ${GH_TOKEN}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/search/code?q=${query}"
}


{
echo "Created temporary storage:"
touch ${BUFF}
touch ${CONC}
ls -Alh --color ${BUFF}
ls -Alh --color ${CONC}

while
    PAGE=$((PAGE+1))
    echo "Processing page ${PAGE}"

    query "${GH_QUERY}&per_page=${GH_PER_PAGE}&page=${PAGE}" > ${BUFF}
    ITEM_COUNT=`{ jq '.items | length' | sed s/\\r//; } < ${BUFF}`
    echo -e "\n\nFetched items: ${ITEM_COUNT}\n\n"
    cat ${BUFF} >> ${CONC}
    sleep 2

    [ ${ITEM_COUNT} = ${GH_PER_PAGE} ]
do :; done
} >/dev/stderr

cat ${CONC} | jq -n '{ items: [inputs.items] | add }' | sed s/\\r// > ${BUFF}
cat ${BUFF}

{
RESULTS_COUNT=`{ jq '.total_count' | sed s/\\r//; } < ${CONC}`
echo -e "\n\nResults count in each query:\n${RESULTS_COUNT}\n\n"

echo "Removing temporary storage:"
rm -v ${BUFF}
rm -v ${CONC}
} >/dev/stderr
