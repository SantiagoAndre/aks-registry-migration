#! /bin/bash
REGISTRY=$1
BACKUP_DIVICIONS=$2
tmpfile="/tmp/backupparts.txt"
mycontainers=$(az acr repository list -n $REGISTRY --output tsv)
echo "pulling images to local machine"
for i in $mycontainers
do

    possile_error="$(docker pull $REGISTRY.azurecr.io/$i --all-tags  -q 2>&1 >/dev/null)"
    if [ ! -z  $possile_error  ]    ; then
        echo "Error while pulling $i image"
        echo "$possile_error"
    fi
   
    
done 



folder="backups/${REGISTRY}/"
mkdir -p $folder

images_count=$(docker images | grep ${REGISTRY}. | wc -l)
images_per_part=$(($images_count/$BACKUP_DIVICIONS))
i=1
echo "images per part $images_per_part"

docker images --format '{{.Repository}}:{{.Tag}}' | grep monolito | xargs -I{} -n $images_per_part  | tee $tmpfile >>/dev/null
while read p; do

    outpartfilename="${folder}-${i}.tar"
    echo "making exported file part $outpartfilename"
    docker save $p -o $outpartfilename
    i=$((i+1))


done <$tmpfile
echo "all images of registry $REGISTRY were succesfuly exported in $outfilename"
echo "to import images to registry execute 'sh import.sh $REGISTRY'"
echo "to import images to registry execute 'docker load -i $outfilename'"

