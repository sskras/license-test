diff:
	diff -u                                                                        \
	  <(                                                                           \
	      cat repo-list-using-blueoak.md                                           \
	    | awk '                                                                    \
	          /^.?https/ {                                                         \
	              NO_PREFIX = gensub(/^(.?)https:..github.com.|~/, "", "g", $$1);  \
	              print gensub( /([^/]+\/[^/]+).*/, "\\1", 1, NO_PREFIX )          \
	          }                                                                    \
	      '                                                                        \
	    | sort -u                                                                  \
	  )                                                                            \
	  ../run-11/repos.txt                                                          \
	|| true

miss:
	$(MAKE) diff                                                                   \
	      | awk '                                                                  \
	            /^-[^-][^-]/ {                                                     \
	                sub(".", "");                                                  \
	                print "<a href=\"https://github.com/"$$1"\">"$$0"</a><br/>"    \
	            }                                                                  \
	        '
