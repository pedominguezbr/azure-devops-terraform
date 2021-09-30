# azure-devops-terraform
infra Azure 

## Generar Service principal para conexion y obtener token para eliminar 
```
# Generar Service principal para conexion via oauth2/token
az ad sp create-for-rbac --name [APP_NAME] --password [CLIENT_SECRET OPTIONAL AUTOGENERADO]

# curl para acceder usando parametros de Service Principal:
curl -X POST -d 'grant_type=client_credentials&client_id=[APP_ID]&client_secret=[PASSWORD]&resource=https%3A%2F%2Fmanagement.azure.com%2F' https://login.microsoftonline.com/[TENANT_ID]/oauth2/token


# Eliminar por Error: creating/updating API Management Service "dev2-apim-service" (Resource Group "terraform-aks-dev2"): apimanagement.ServiceClient#CreateOrUpdate: Failure sending request: StatusCode=0 -- Original Error: autorest/azure: Service returned an error. Status=<nil> Code="ServiceAlreadyExistsInSoftDeletedState" Message="Api service dev2-apim-service was soft-deleted. In order to create the new service with the same name, you have to either undelete the service or purge it. See https://aka.ms/apimsoftdelete."

DELETE https://management.azure.com/subscriptions/4b14091a-eb5b-48c8-ba4a-b3157f805672/providers/Microsoft.ApiManagement/locations/eastus2/deletedservices/dev2-apim-service?api-version=2021-01-01-preview

```
