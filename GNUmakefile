all:
	@echo "TODO: merge Git repos with the parent dir (../fetch-Blue-Oak-model-license-from-GitHub.sh)"

run:
	@sh github-api-query.sh > github-api-query-response.json
	@git diff
	@git commit -m 'github-api-query-response.json: Ordinary add.' github-api-query-response.json || true

count:
	@cat repo-list-using-blueoak.md                                                \
	  | grep -E '^[~|?]?https:' -c

diff:
	@diff -u                                                                       \
	  <(                                                                           \
	      cat repo-list-using-blueoak.md                                           \
	    | awk '                                                                    \
	          /^[|>?*]? ?https/ {                                                  \
	              NO_PREFIX = gensub(/^.? ?https:..github.com.|~/, "", "g", $$1);  \
	              print gensub( /([^/]+\/[^/]+).*/, "\\1", 1, NO_PREFIX )          \
	          }                                                                    \
	      '                                                                        \
	    | sort -u                                                                  \
	  )                                                                            \
	  ./repos.txt                                                                  \
	|| true

htmlize:
	@awk '                                                                         \
	    !/^make\[/{                                                                \
	        sub(".", "");                                                          \
	        print "<a href=\"https://github.com/"$$1"\">"$$0"</a><br/>"            \
	    }                                                                          \
	'

miss:
	@$(MAKE) diff                                                                  \
	  | grep '^-[^-][^-]'                                                          \
	 || true

added:
	@$(MAKE) diff                                                                  \
	  | grep '^+[^+][^+]'                                                          \
	 || true

miss-html:
	@$(MAKE) miss                                                                  \
	  | $(MAKE) htmlize                                                            \
	  | grep -v ^make                                                              \
	 || true

added-html:
	@$(MAKE) added                                                                 \
	  | $(MAKE) htmlize                                                            \
	  | grep -v ^make                                                              \
	 || true
