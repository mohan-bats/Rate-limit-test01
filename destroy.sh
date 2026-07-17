#!/bin/bash

echo "Deleting created files..."

for i in {1..10}; do
    filename="file${i}.txt"

    if [[ -f "$filename" ]]; then
        rm "$filename"
        echo "Deleted: $filename"
    else
        echo "Not found: $filename"
    fi
done

echo "Cleanup complete."
