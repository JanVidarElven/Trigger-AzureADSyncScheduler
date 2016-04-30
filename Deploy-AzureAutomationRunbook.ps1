
# 1. Log in Azure account
Add-AzureRmAccount

# 2. If account has access to multiple subscriptions, set which to deploy to
Set-AzureRmContext -SubscriptionID <YourSubscriptionId>

# 3. Create a new resource group if you are not deploying to an existing one
New-AzureRmResourceGroup -Name MyAutomationResourceGroup -Location "West Europe"

# 4. Test Deployment
Test-AzureRmResourceGroupDeployment -ResourceGroupName MyAutomationResourceGroup -TemplateFile .\azuredeploy.json -AutomationAccountName "MyAutomationAccount" `
 -AAHybridWorkerCredentialName "AAHybridWorkerSvcAccount" -AAHybridWorkerDomain "MyDOMAIN" -AAHybridWorkerUserName "MySvc_HybridWorker" `
 -AAHybridWorkerPassword (ConvertTo-SecureString "MyPassword" -AsPlainText -Force) -AADSServerName "MyAADSServer"

# 5. Deploy with either of the following methods:
# 5a. Deploy with Inline parameters
New-AzureRmResourceGroupDeployment -Name MyAutomationDeployment -ResourceGroupName MyAutomationResourceGroup -TemplateFile .\azuredeploy.json -AutomationAccountName "MyAutomationAccount" `
 -AAHybridWorkerCredentialName "AAHybridWorkerSvcAccount" -AAHybridWorkerDomain "MyDOMAIN" -AAHybridWorkerUserName "MySvc_HybridWorker" `
 -AAHybridWorkerPassword (ConvertTo-SecureString "MyPassword" -AsPlainText -Force) -AADSServerName "MyAADSServer"

# 5b. Deploy with Parameter object
$parameters = @{
    "AutomationAccountName"="MyAutomationAccount"
    "AAHybridWorkerCredentialName"="AAHybridWorkerSvcAccount"
    "AAHybridWorkerDomain"="MyDOMAIN"
    "AAHybridWorkerUserName"="MySvc_HybridWorker"
    "AAHybridWorkerPassword"="MyPassword"
    "AADSServerName"="MyAADSServer"
}
New-AzureRmResourceGroupDeployment -Name MyAutomationDeployment -ResourceGroupName MyAutomationResourceGroup -TemplateFile .\azuredeploy.json -TemplateParameterObject $parameters

# 5c. Deploy with Parameter file
New-AzureRmResourceGroupDeployment -Name MyAutomationDeployment -ResourceGroupName MyAutomationResourceGroup -TemplateFile .\azuredeploy.json -TemplateParameterFile .\azuredeploy.parameters.json

