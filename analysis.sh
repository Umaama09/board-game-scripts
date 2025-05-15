#!/bin/bash

input="$1"

tail -n +2 "$input" | awk -F'\t' '
function split_clean(str, arr,   i, tmp, count) {
    count = split(str, tmp, /[.,;]/)
    for (i = 1; i <= count; i++) {
        gsub(/^[ \t]+|[ \t]+$/, "", tmp[i])  # Trim whitespace
        if (tmp[i] != "" && tmp[i] != "Game" && tmp[i] != "Games")
            arr[tmp[i]]++
    }
}

{
    if ($13 != "")
        split_clean($13, mechanics)

    if ($14 != "")
        split_clean($14, domains)

    if ($3 != "" && $9 != "") {
        years[++ny] = $3
        ratings_y[ny] = $9
    }

    if ($11 != "" && $9 != "") {
        complexity[++nc] = $11
        ratings_c[nc] = $9
    }
}

END {
    maxm = 0
    for (k in mechanics) {
        if (mechanics[k] > maxm) {
            maxm = mechanics[k]
            mech = k
        }
    }

    maxd = 0
    for (k in domains) {
        if (domains[k] > maxd) {
            maxd = domains[k]
            dom = k
        }
    }

    print "The most popular game mechanics is " mech " found in " maxm " games"
    print "The most style of game is " dom " found in " maxd " games"

    sum_x = sum_y = sum_xy = sum_x2 = sum_y2 = 0
    for (i = 1; i <= ny; i++) {
        x = years[i]
        y = ratings_y[i]
        sum_x += x
        sum_y += y
        sum_xy += x * y
        sum_x2 += x * x
        sum_y2 += y * y
    }

    r_y = (ny * sum_xy - sum_x * sum_y) / sqrt((ny * sum_x2 - sum_x^2) * (ny * sum_y2 - sum_y^2))
    printf "The correlation between the year of publication and the average rating is %.3f\n", r_y

    sum_x = sum_y = sum_xy = sum_x2 = sum_y2 = 0
    for (i = 1; i <= nc; i++) {
        x = complexity[i]
        y = ratings_c[i]
        sum_x += x
        sum_y += y
        sum_xy += x * y
        sum_x2 += x * x
        sum_y2 += y * y
    }

    r_c = (nc * sum_xy - sum_x * sum_y) / sqrt((nc * sum_x2 - sum_x^2) * (nc * sum_y2 - sum_y^2))
    printf "The correlation between the complexity of a game and its average rating is %.3f\n", r_c
}
'