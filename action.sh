#!/bin/sh
set -e

timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

INPUT_AUTHOR_EMAIL=${INPUT_AUTHOR_EMAIL:-'github-actions-swift-format[bot]@users.noreply.github.com'}
INPUT_AUTHOR_NAME=${INPUT_AUTHOR_NAME:-'github-actions-swift-format[bot]'}
INPUT_MESSAGE=${INPUT_MESSAGE:-"swift-format ${timestamp}"}
INPUT_BRANCH=${INPUT_BRANCH:-master}
INPUT_EMPTY=${INPUT_EMPTY:-false}
INPUT_DIRECTORY=${INPUT_DIRECTORY:-'.'}
REPOSITORY=${INPUT_REPOSITORY:-$GITHUB_REPOSITORY}
DIR=$(pwd)

cd ../
VERSION=$(swift --version | head -1 | cut -d '(' -f 2 | cut -d ')' -f 1)
echo "Build swift-format $VERSION";
git clone https://github.com/apple/swift-format.git
cd swift-format
git checkout "tags/$VERSION"
swift build -c release

sudo cp -f .build/release/swift-format /usr/bin/swift-format

cd $DIR
echo "Run swift-format recursively on '.swift' files in directory.";
swift-format format -i -p --ignore-unparsable-files -r "${INPUT_DIRECTORY}"

echo "Push to branch $INPUT_BRANCH";
[ -z "${INPUT_GITHUB_TOKEN}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};

if ${INPUT_EMPTY}; then
    _EMPTY='--allow-empty'
fi

cd "${INPUT_DIRECTORY}"
remote_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${REPOSITORY}.git"

git config http.sslVerify false
git config --local user.email "${INPUT_AUTHOR_EMAIL}"
git config --local user.name "${INPUT_AUTHOR_NAME}"

git add -A

git commit -m "${INPUT_MESSAGE}" $_EMPTY || exit 0

git push "${remote_repo}" HEAD:"${INPUT_BRANCH}";