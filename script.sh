#!/bin/bash

# --------------------------
# 1️⃣ Criar Resource Group
# --------------------------
az group create --name rg-tria --location brazilsouth

# --------------------------
# 2️⃣ Build e Push MySQL
# --------------------------
docker build -f mysql/Dockerfile -t mysql mysql

# Criar ACR para MySQL
az acr create \
    --resource-group rg-tria \
    --name mysqltria \
    --sku Standard \
    --location brazilsouth \
    --public-network-enabled true \
    --admin-enabled true

# Pegar dados do ACR
LOGIN_SERVER=$(az acr show --name mysqltria --resource-group rg-tria --query loginServer --output tsv)
ADMIN_USERNAME=$(az acr credential show --name mysqltria --resource-group rg-tria --query username --output tsv)
ADMIN_PASSWORD=$(az acr credential show --name mysqltria --resource-group rg-tria --query passwords[0].value --output tsv)

echo "MySQL ACR Login Server: $LOGIN_SERVER"
echo "Username: $ADMIN_USERNAME"
echo "Password: $ADMIN_PASSWORD"

# Login no ACR
az acr login --name mysqltria

# Tag e push da imagem
docker tag mysql $LOGIN_SERVER/mottu-mysql:v1
docker push $LOGIN_SERVER/mottu-mysql:v1

# --------------------------
# 3️⃣ Subir MySQL no ACI
# --------------------------
az container create \
    --resource-group rg-tria \
    --name mysql-container \
    --image $LOGIN_SERVER/mottu-mysql:v1 \
    --cpu 1 \
    --memory 2 \
    --registry-login-server $LOGIN_SERVER \
    --registry-username $ADMIN_USERNAME \
    --registry-password $ADMIN_PASSWORD \
    --ports 3306 \
    --os-type Linux \
    --environment-variables MYSQL_ROOT_PASSWORD=MinhaSenhaSegura MYSQL_DATABASE=tria_app \
    --ip-address Public

# Pegar IP público do MySQL
MYSQL_IP=$(az container show --resource-group rg-tria --name mysql-container --query ipAddress.ip --output tsv)
echo "MySQL IP Público: $MYSQL_IP"

# --------------------------
# 4️⃣ Build e Push API .NET
# --------------------------
docker build -t api-dotnet -f dotnet/Tria_2025/Dockerfile dotnet/Tria_2025

# Criar ACR para API .NET (pode ser o mesmo ou outro)
az acr create \
    --resource-group rg-tria \
    --name dotnettria \
    --sku Standard \
    --location brazilsouth \
    --admin-enabled true

API_LOGIN_SERVER=$(az acr show --name dotnettria --resource-group rg-tria --query loginServer --output tsv)
API_ADMIN_USERNAME=$(az acr credential show --name dotnettria --resource-group rg-tria --query username --output tsv)
API_ADMIN_PASSWORD=$(az acr credential show --name dotnettria --resource-group rg-tria --query passwords[0].value --output tsv)
az acr login --name dotnettria

docker tag api-dotnet $API_LOGIN_SERVER/dotnet-api:v1
docker push $API_LOGIN_SERVER/dotnet-api:v1

# --------------------------
# 5️⃣ Subir API .NET no ACI
# --------------------------
az container create \
    --resource-group rg-tria \
    --name api-dotnet \
    --image $API_LOGIN_SERVER/dotnet-api:v1 \
    --cpu 1 \
    --memory 2 \
    --registry-login-server $API_LOGIN_SERVER \
    --registry-username $API_ADMIN_USERNAME \
    --registry-password $API_ADMIN_PASSWORD \
    --os-type Linux \
    --ports 8080 \
    --ip-address Public \
    --environment-variables ConnectionStrings__DefaultConnection="Server=$MYSQL_IP;Port=3306;Database=tria_app;Uid=root;Pwd=MinhaSenhaSegura;"


