#!/bin/bash

filename="$1"
separator="$2"

awk -v sep="$separator" '
BEGIN {
    FS = sep
}

NR == 1 {
    gsub(/\r$/, "", $0);
    for (i = 1; i <= NF; i++) {
        column_names[i] = $i
        empty_counts[i] = 0
    }
    num_columns = NF
    next
}

{
    gsub(/\r$/, "", $0);
    for (i = 1; i <= num_columns; i++) {
        if ($i == "") {
            empty_counts[i]++
        }
    }
}

END {
    for (i = 1; i <= num_columns; i++) {
        print column_names[i] ": " empty_counts[i]
    }
}
' "$filename"
