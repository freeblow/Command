
#!/bin/bash

set -e

echo "=== Fetching origin... ==="
git fetch origin --prune

echo "=== Creating local branches for all origin/* ==="

for branch in $(git branch -r | grep origin/ | grep -v HEAD); do
    local_branch=${branch#origin/}
    
    if git show-ref --verify --quiet refs/heads/$local_branch; then
        echo "Local branch already exists: $local_branch"
    else
        echo "Creating local branch: $local_branch"
        git branch --track $local_branch $branch 2>/dev/null || \
            git checkout -b $local_branch $branch
    fi
done

echo "=== Pushing all branches to new-origin... ==="
git push new-origin --all

echo "=== Pushing tags... ==="
git push new-origin --tags

echo "=== Done! All branches and tags synced to new-origin ==="
