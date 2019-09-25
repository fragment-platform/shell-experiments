#!/usr/bin/env bash
# TODO: use pure sh
set -e

# TODO: parse args way better than not at all
# TODO: consider arg for blog url, curl in the key or something
if [ -z "$2" ]; then
    echo "usage: verify-post [post file] [public key]"
    exit 1
fi

post_file=$1
public_key=$PWD/$2

unzip -qq $post_file -d .fragment_post_verify

wd=$PWD
cd .fragment_post_verify
signify -C -p $public_key -x SHA256.sig
cd $wd

rm -rf .fragment_post_verify
