#!/bin/bash

set -e

echo "Creating 10 files..."

for i in {1..10}; do
    filename="file${i}.txt"
    echo "This is ${filename}" > "$filename"
    echo "Created: $filename"
done

echo "Done! 10 files created."
