# Trigger-AzureADSyncScheduler
Azure Automation Runbook work triggering Azure AD Sync Scheduler

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fskillriver%2FTrigger-AzureADSyncScheduler%2Fmaster%2Fazuredeploy.json) 

This repository is for Azure Resource Manager and creating an Azure Automation Runbook, as demoed on my blog at http://systemcenterpoint.wordpress.com.

This sample shows how you can deploy a PowerShell script runbook, a credential asset and a variable asset the runbook relies on, through an Azure Resource Manager template. 

It also contains a sample script, Deploy-AzureAutomationRunbook.ps1, that you can use to get you started with the deployment from PowerShell. 

##Requirements
This solution requires that you have access to an existing Azure Subscription. You will also need to either specify an existing Azure Automation Account, or a new one will be created for you with the name specified.

After the solution is deployed, there is a requirements for an on-premise environment where:
- Azure AD Connect Server must be installed
- A Hybrid Worker must be installed and be able to do a remote session to the Azure AD Connect Server
- A local domain credential must be allowed to authenticate to the remote Azure AD Connector Server

All this is explained more in the above mentioned blog post.

##Resources Deployed
This resource template will deploy the following resources.
###Azure Automation Runbook
A PowerShell Script Runbook that will run on a Hybrid Worker, connecting to the Azure AD Connect Server, and triggering a delta sync. 

###Variable Asset for Azure AD Sync Server
A string variable asset that contains the computer name of the Azure AD Connect Server in your environment.

###Credential Asset for Hybrid Worker Run As Account
A credential asset containing the DOMAIN\username and password for the run as account that has permission to connect to and trigger Azure AD Sync Scheduler.  

## Deployment instructions
You can deploy this resource template with one of two methods:
- Use the Deploy to Azure button above. This will launch a template deployment in the Azure portal you are logged in to. See blog post for instructions and details.
- Deploy with Azure Resource Manager PowerShell. See below for instructions:

### Deploy with PowerShell

You can deploy this solution with AzureRM PowerShell CmdLets. I have included a PowerShell script with CmdLets for deploying, Deploy-AzureAutomationRunbook.ps1:

1. Log in Azure account
Add-AzureRmAccount

2. If account has access to multiple subscriptions, set which to deploy to
Set-AzureRmContext -SubscriptionID <YourSubscriptionId>

3. Create a new resource group if you are not deploying to an existing one
New-AzureRmResourceGroup -Name MyAutomationResourceGroup -Location "<Your Location>"

4. Test Deployment
Test-AzureRmResourceGroupDeployment -ResourceGroupName MyAutomationResourceGroup -TemplateFile .\azuredeploy.json -AutomationAccountName "MyAutomationAccount" `
 -AAHybridWorkerCredentialName "AAHybridWorkerSvcAccount" -AAHybridWorkerDomain "MyDOMAIN" -AAHybridWorkerUserName "MySvc_HybridWorker" `
 -AAHybridWorkerPassword (ConvertTo-SecureString "MyPassword" -AsPlainText -Force) -AADSServerName "MyAADSServer"

5. Deploy with either of the following methods:
6. Deploy with Inline parameters
New-AzureRmResourceGroupDeployment -Name MyAutomationDeployment -ResourceGroupName MyAutomationResourceGroup -TemplateFile .\azuredeploy.json -AutomationAccountName "MyAutomationAccount" `
 -AAHybridWorkerCredentialName "AAHybridWorkerSvcAccount" -AAHybridWorkerDomain "MyDOMAIN" -AAHybridWorkerUserName "MySvc_HybridWorker" `
 -AAHybridWorkerPassword (ConvertTo-SecureString "MyPassword" -AsPlainText -Force) -AADSServerName "MyAADSServer"

7. Deploy with Parameter object
$parameters = @{
    "AutomationAccountName"="MyAutomationAccount"
    "AAHybridWorkerCredentialName"="AAHybridWorkerSvcAccount"
    "AAHybridWorkerDomain"="MyDOMAIN"
    "AAHybridWorkerUserName"="MySvc_HybridWorker"
    "AAHybridWorkerPassword"="MyPassword"
    "AADSServerName"="MyAADSServer"
}
New-AzureRmResourceGroupDeployment -Name MyAutomationDeployment -ResourceGroupName MyAutomationResourceGroup -TemplateFile .\azuredeploy.json -TemplateParameterObject $parameters

8. Deploy with Parameter file
New-AzureRmResourceGroupDeployment -Name MyAutomationDeployment -ResourceGroupName MyAutomationResourceGroup -TemplateFile .\azuredeploy.json -TemplateParameterFile .\azuredeploy.parameters.json



 