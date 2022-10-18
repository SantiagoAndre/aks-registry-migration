#! /bin/bash
outfilename="allimages_of$1.tar"
docker load -i $outfilename 
for image in $(docker images --format '{{.Repository}}:{{.Tag}}' | grep $1)
do
    docker push $image
done
