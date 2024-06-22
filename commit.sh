#!/bin/bash

git add --all

read -p "Enter a commit message: " commit_message
git commit -m "$commit_message"

git push https://Aziangelo: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@github.com/Aziangelo/AF-Natural.git

