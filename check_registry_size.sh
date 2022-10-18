#! /bin/bash
REGISTRY=$1
mycontainers=$(az acr repository list -n $REGISTRY --output tsv)
total_size=0
for i in $mycontainers
do
    # mytags=$(az acr repository show-tags -n $REGISTRY --repository $i --output tsv)
    isize=$(az acr repository show-manifests  --repository $i  -n $REGISTRY --detail --query '[].{Size: imageSize}' | tail -n +1| jq -r .[0].Size)
    total_size=$((total_size+isize))
    echo "$i = $isize"
done 
total_size_gb=$((total_size/1000000000))
echo "the registry $REGISTRY size is $total_size bites"
echo "the registry $REGISTRY size is ${total_size_gb}GB"
# outfilename="allimages_of${REGISTRY}.tar"
# docker save $(docker images --format '{{.Repository}}:{{.Tag}}'|grep -v none ) -o $outfilename
# echo "all images of registry $REGISTRY were succesfuly exported in $outfilename"
# echo "to import images to registry execute `sh import.sh $REGISTRY`"
# echo "to import images to registry execute `sh import.sh $REGISTRY`"
