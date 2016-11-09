#!/bin/bash

if [ $# -ne 2 ]; then

        echo -e "Usage:\n $0 <OLD_VERSION> <NEW_VERSION\n\nexample:\n $0 v4.4.27-rt37 v4.4.27-rt38"
        exit 64
fi

OLD_VERSION=$1
NEW_VERSION=$2

FILE_LIST=".gitlab-ci.yml README.md tools/prepare_uboot.sh tools/prepare_kernel.sh"

sed -i "s/${OLD_VERSION}/${NEW_VERSION}/g" ${FILE_LIST}
