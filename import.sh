#! /bin/bash
REGISTRY=$1
BACKUP_NUMBER=$2

if [ -z "$BACKUP_NUMBER" ]
then
    PARTS=$(ls backups/${REGISTRY}/*.tar) 
else
    PARTS="backups/${REGISTRY}/${BACKUP_NUMBER}.tar"
fi
for part in $PARTS
do
    echo "importing backup file $part"
    docker load -i $part 
done

for image in $(docker images --format '{{.Repository}}:{{.Tag}}' | grep $REGISTRY)
do
    docker push $image
done
