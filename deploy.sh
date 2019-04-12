#!/bin/sh

RESOURCE_GROUP="<RESOURCE GROUP>"
REGION="<REGION: japaneast>"
APP_NAME="<APP SERVICE NAME>"
APP_PLAN_NAME="<APP SERVICE PLAN NAME>"
CONFIG_FILE=codeserver.yaml

set -e -x
cwd=`dirname "$0"`
expr "$0" : "/.*" > /dev/null || cwd=`(cd "$cwd" && pwd)`

echo "Create Resource Group: $RESOURCE_GROUP"
az group create --name $RESOURCE_GROUP --location $REGION

echo "Create App Service Plan: $APP_PLAN_NAME"
az appservice plan create \
  --name $APP_PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --sku S1 --is-linux

echo "Create Web App for Container: $APP_NAME"
az webapp create \
  --resource-group $RESOURCE_GROUP \
  --plan $APP_PLAN_NAME \
  --name $APP_NAME \
  --multicontainer-config-type compose \
  --multicontainer-config-file $cwd/$CONFIG_FILE

echo "Add App Setting"
az webapp config appsettings set \
  --resource-group $RESOURCE_GROUP \
  --name $APP_NAME \
  --settings WEBSITES_ENABLE_APP_SERVICE_STORAGE=TRUE

echo "Done!!"
echo ""
echo "Access the code-server:"
echo "open https://$APP_NAME.azurewebsites.net"
echo ""
