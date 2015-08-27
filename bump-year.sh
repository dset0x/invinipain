#!/bin/bash

# This script will try to bump copyright dates in a in master..HEAD range of
# your current git repository.

# YOU ARE ON YOUR OWN.

CURRENT_YEAR="$(date +'%Y')"
for hash in $(git log --pretty=tformat:'%H' master..HEAD | tac); do
    GIT_SEQUENCE_EDITOR="sed -i -re \"s/^pick ${hash:0:8}/e /\"" git rebase -i ${hash}~ || exit 1
    # git reset HEAD~ || exit 1
    git diff -z --name-only HEAD~ | \
    while read -r -d $'\0' file; do
        if [ -f "$file" ]; then
            # sed -ri 's/(#+\ ?Copyright .* [0-9]{4}) CERN/\1, '"$CURRENT_YEAR"' CERN/' "$file" || exit 1
            # sed -ri 's/'"$CURRENT_YEAR"', '"$CURRENT_YEAR"' CERN/'"$CURRENT_YEAR"' CERN/' "$file" || exit 1

            # Lines with ^Copyright
            perl -0777 -pe -i.original 's/(#+\ ?Copyright .* [0-9]{4}) CERN/\1, '"$CURRENT_YEAR"' CERN/igs' "$file" || exit 1

            # Secondary line
            perl -0777 -pe -i.original 's/(#+\ ([0-9]{4}(,\ )?)+)\ CERN/\1, '"$CURRENT_YEAR"' CERN/igs' "$file" || exit 1

            # Amend places where $CURRENT_YEAR was already the current year
            perl -0777 -pe -i.original 's/'"$CURRENT_YEAR"', '"$CURRENT_YEAR"' CERN/'"$CURRENT_YEAR"' CERN/igs' "$file" || exit 1
        fi
    done
    git add -u || exit 1
    git commit --amend --no-edit || exit 1
    # git log --format='%B' -n 1 HEAD@{1} | git commit -F - || exit 1
    [ -e $(git ls-files -m) ] && "$SHELL" || exit 1
    git rebase --continue || exit 1
done
