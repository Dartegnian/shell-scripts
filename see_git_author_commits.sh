#! /usr/bin/env bash

git log --since=2021-01-01 --format='%aN <%aE>' | sort | uniq -c | sort -nr |
while read count author_email; do
	author_name=$(echo "$author_email" | cut -d'<' -f1 | sed 's/^[[:space:]]*//')
	last_commit_date=$(git log -n 1 --author="$author_name" --format="%ad" --date=format:'%Y-%m-%d')
	echo "$count commit(s) - last commit: $last_commit_date - $author_email"
done
