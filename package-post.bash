#!/usr/bin/env bash
# TODO: use pure sh
set -e

# TODO: actually check if signify is available

# TODO: parse args way better than not at all
if [ -z "$2" ]; then
    echo "usage: package-post [post folder] [private key]"
    exit 1
fi

post_folder=$1
private_key=$2


wd=$PWD
cd $post_folder
# TODO: find * might not work with hidden files
# TODO: sha256sum is not portable - check for OS?
rm -f SHA256.sig # may or may not exist but we wouldn't want to generate its checksum
find * -type f -print0 | xargs -0 sha256sum | awk '{print "SHA256 ("$2") = "$1}' > SHA256
cd $wd


signify -S -e -s $private_key -m $post_folder/SHA256

rm $post_folder/SHA256 # we have the signed one now

# TODO: add blog url as comment
sed -i "" "1s/.*/untrusted comment: TODO: insert blog URL here (oh my god the slash escaping)/" "$post_folder/SHA256.sig"

# TODO: this breaks badly if a proper path is given and not just folder name
cd $post_folder
zip -r $wd/$post_folder.post *

