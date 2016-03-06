#!/bin/bash

hc() {
	herbstclient "$@"
}

tag=$(hc tag_status \
	| tr '\t' '\n' \
	| grep '#'\
	)

hc use_index -1 --skip-visible
hc merge_tag ${tag:1}
