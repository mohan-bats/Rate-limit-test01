#!/usr/bin/env bash

set -euo pipefail

BASE_BRANCH="${1:-main}"
TOTAL_PRS="${2:-11}"
PREFIX="coderabbit-rate-limit-test"
START_BRANCH="$(git branch --show-current)"

if ! command -v gh >/dev/null 2>&1; then
    echo "Error: GitHub CLI (gh) is not installed."
    echo "Install it with: brew install gh"
    exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
    echo "Error: GitHub CLI is not authenticated."
    echo "Run: gh auth login"
    exit 1
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Error: Your repository has uncommitted changes."
    echo "Commit or stash them before running this test."
    exit 1
fi

echo "Updating the base branch..."
git checkout "$BASE_BRANCH"
git pull origin "$BASE_BRANCH"

for i in $(seq 1 "$TOTAL_PRS"); do
    BRANCH="${PREFIX}-${i}"
    TEST_FILE="rate-limit-test-${i}.py"

    echo
    echo "Creating PR ${i}/${TOTAL_PRS}: ${BRANCH}"

    git checkout -b "$BRANCH" "$BASE_BRANCH"

    cat > "$TEST_FILE" <<EOF
"""CodeRabbit rate-limit test file ${i}."""


def divide_numbers_${i}(first_number, second_number):
    # Deliberately missing zero validation for review testing.
    return first_number / second_number


def get_first_item_${i}(items):
    # Deliberately missing empty-list validation for review testing.
    return items[0]
EOF

    git add "$TEST_FILE"
    git commit -m "Add CodeRabbit rate-limit test ${i}"
    git push -u origin "$BRANCH"

    PR_URL="$(
        gh pr create \
            --base "$BASE_BRANCH" \
            --head "$BRANCH" \
            --title "CodeRabbit rate-limit test ${i}" \
            --body "Disposable PR created to test the Pro Plus PR-review rolling rate limit."
    )"

    echo "Created: $PR_URL"

    git checkout "$BASE_BRANCH"

    # Small delay so GitHub events are delivered independently.
    sleep 10
done

git checkout "$START_BRANCH"

echo
echo "Created ${TOTAL_PRS} pull requests."
echo "Watch each PR for CodeRabbit responses."
echo "The 11th eligible review should reach the Pro Plus limit if:"
echo "  - all reviews belong to the same developer"
echo "  - all 10 earlier reviews ran within the rolling one-hour window"
echo "  - the usage-based add-on is disabled"
echo "  - no custom or trial limits apply"
