#!/bin/bash

input="$1"

cleaned=$(mktemp)

cat "$input" | \
    tr -d '\r' | \
    tr -cd '\11\12\15\40-\176' | \
    sed 's/,/./g' > "$cleaned"

awk -F';' '
BEGIN {
    OFS = "\t"
    max_id = 0
}

NR == 1 {
    print $0
    next
}

{
    if ($1 ~ /^[0-9]+$/) {
        id = int($1)
        if (id > max_id) {
            max_id = id
        }
    }

    data[NR] = $0
    is_empty_id[NR] = ($1 == "")
}

END {
    new_id = max_id + 1
    for (i = 2; i < NR + 1; i++) {
        n = split(data[i], fields, FS)
        if (is_empty_id[i]) {
            fields[1] = new_id++
        }
        for (j = 1; j <= n; j++) {
            gsub(";", "\t", fields[j])
        }
        print join(fields, n)
    }
}

function join(arr, len,   s, i) {
    s = arr[1]
    for (i = 2; i <= len; i++) {
        s = s OFS arr[i]
    }
    return s
}
' "$cleaned"

rm "$cleaned"