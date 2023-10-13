# TODO


export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"

### get admin
AKS_ID=$(az aks show --name cdpaks-aks --resource-group  cdp-group --query id -o tsv)
APPDEV_ID=$(az ad group show --group cdpdev --query id)


az aks get-credentials --resource-group cdp-group --name cdpaks-aks --admin

### Errors
AADSTS7000215 --> https://learn.microsoft.com/de-de/troubleshoot/azure/azure-kubernetes/error-code-serviceprincipalvalidationclienterror 