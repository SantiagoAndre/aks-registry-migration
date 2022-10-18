#! /bin/bash
REGISTRY=$1
mycontainers=$(az acr repository list -n $REGISTRY --output tsv)
echo "pulling images to local machine"
for i in $mycontainers
do

    # docker pull $REGISTRY.azurecr.io/$i:$j
    possile_error="$(docker pull $REGISTRY.azurecr.io/$i --all-tags  -q 2>&1 >/dev/null)"
    if [ ! -z  $possile_error  ]    ; then
        echo "Error while pulling $i image"
        echo "$possile_error"
    fi
    # printf  "$REGISTRY.azurecr.io/$i:$j\n"
    # az acr repository show-tags -n $REGISTRY --repository $i --output tsv|tail -1
    
    
done 


outfilename="allimages_of${REGISTRY}.tar"
echo "making exported file $outfilename"
docker save $(docker images --format '{{.Repository}}:{{.Tag}}'|grep $REGISTRY ) -o $outfilename
echo "all images of registry $REGISTRY were succesfuly exported in $outfilename"
echo "to import images to registry execute 'sh import.sh $REGISTRY'"
echo "to import images to registry execute 'docker load -i $outfilename'"
