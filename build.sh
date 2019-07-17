#!/bin/bash
set -x

mkdir artifacts

export LATEST_VERSION="$(date)"
echo "${LATEST_VERSION}" > artifacts/LATEST_VERSION

mkdir tmp
git clone https://github.com/ytdl-org/youtube-dl tmp/ytdl --depth=1
cd tmp/ytdl

# remake version.py
echo "from __future__ import unicode_literals

__version__ = '${LATEST_VERSION}'
" > youtube_dl/version.py

for i in "$(ls ../../patches)" ; do
  patch -p1 < "../../patches/$i"
done
make youtube-dl

cd ../../
mv tmp/ytdl/youtube-dl artifacts

rm -rf tmp

FILEHASH="$(sha256sum artifacts/youtube-dl | awk '{print $1}')"

echo '{"versions":{}}' | jq ".latest=\"${LATEST_VERSION}\"" \
  | jq ".versions[\"${LATEST_VERSION}\"].bin=[\"https://nao20010128nao.github.io/ytdl-patched/youtube-dl\",\"${FILEHASH}\"]" \
  | tee artifacts/versions.json
