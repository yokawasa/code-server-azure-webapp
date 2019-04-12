#!/bin/sh

RESOURCE_GROUP=RG-yoichika-demox
echo "Clean up Resourcde Group: $RESOURCE_GROUP"
az group delete --name $RESOURCE_GROUP