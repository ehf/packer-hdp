#!/usr/bin/env bash


#
# requires installation of packer on your local host (wherever this script is run): 
# https://www.packer.io/downloads.html
#


#set -o errexit
#set -o nounset
set -o xtrace




readonly TEMPLATE=./templates/gcp-bdp-image.json

# example image name: hdp-latest-v20161227-14
IMAGE_DATE=$(date +%Y%m%d-%S)
HDPVER="2650-292"
IMAGE_VERSION="hdp-${HDPVER}"
IMAGE="${IMAGE_VERSION}-v${IMAGE_DATE}"
PROJECT="devcos-mma1"
SOURCE_IMAGE="centos-7-latest"

err() {
    echo "[$(date +'%F %T %Z')]: $@" >&2
    exit 1
}


# build image
if [[ -s ${TEMPLATE} ]]; then
    cd ${PROGDIR}
    packer validate -var "image_name=${IMAGE}" ${TEMPLATE} || err "validation of ${TEMPLATE} failed" 
    PACKER_LOG=1 packer build -var "image_name=${IMAGE}" -var "project_name=${PROJECT}" -var "src_image=${SOURCE_IMAGE}" ${TEMPLATE} 
    ##packer build -var "image_name=${IMAGE}" ${TEMPLATE} 
else
    err "${TEMPLATE} template file does not exist"
fi


exit 0
#--DONE
