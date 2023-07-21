#!/bin/sh

## This script will find duplicate people across all the CSV files in the current directory.

temp_file=$(mktemp)

for csv_file in *.csv; do
    sed '1d' "$csv_file" | while IFS=, read -r first_name last_name; do
        # Titleize first name and uppercase last name
        first_name=$(echo "$first_name" | sed 's/\b\(.\)/\u\1/g')
        last_name=$(echo "$last_name" | tr '[:lower:]' '[:upper:]')

        echo "$first_name $last_name:$csv_file" >> "$temp_file"
    done
done

duplicates=$(cut -d: -f1 < "$temp_file" | sort | uniq -D | uniq)

if [ -n "$duplicates" ]; then
    echo "Duplicates found!"

    echo "$duplicates" | while read -r duplicate; do
        echo "Found $duplicate in:"
        grep "^$duplicate:" "$temp_file" | cut -d: -f2 | sed 's/^/\t- /'
    done
else
    echo "No duplicates found."
    exit 0
fi

rm "$temp_file"
