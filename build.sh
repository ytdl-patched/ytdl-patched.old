#!/bin/bash
set -x

mkdir tmp
git clone https://github.com/ytdl-org/youtube-dl tmp/ytdl --depth=1
cd tmp/ytdl
for i in "$(ls ../../patches)" ; do
  patch -p1 < "../../patches/$i"
done
make youtube-dl

cd ../../
mv tmp/ytdl/bin/youtube-dl .

rm -rf tmp