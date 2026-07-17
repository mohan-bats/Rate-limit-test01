#!/bin/bash

set -e

BRANCH="mcs-branch01"

for i in {1..10}; do
    echo "Iteration $i"

    # Create
    cat > myscript.sh <<EOF
#!/bin/bash
echo "Iteration $i"
EOF
    chmod +x myscript.sh

    git add myscript.sh
    git commit -m "Iteration $i: create myscript.sh"
    git push origin "$BRANCH"

    # Destroy
    rm -f myscript.sh

    git add -A
    git commit -m "Iteration $i: delete myscript.sh"
    git push origin "$BRANCH"
done

echo "Completed 10 iterations (20 commits)."
