Function AzureLookUp
{

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null

#region Generated Form Objects

$AzureForm = New-Object System.Windows.Forms.Form
$AzureTextBox = New-Object System.Windows.Forms.TextBox 
$AzureTextBoxLabel = New-Object System.Windows.Forms.Label
$AzureLookUpButton = New-Object System.Windows.Forms.Button
$InitialAzureFormWindowState = New-Object System.Windows.Forms.FormWindowState

#endregion Generated Form Objects

#———————————————-
#Generated Event Script Blocks
#———————————————-
#Provide Custom Code for events specified in PrimalForms.
$handler_AzureLookUpButton_Click=
{
 
if (Get-Module -ListAvailable -Name AzureAD) {
    Write-Host "Module exists"
} 
else {
    Install-Module AzureAD -Force
}

if (Get-Module -ListAvailable -Name MSOnline) {
    Write-Host "Module exists"
} 

else {
    Install-module MSOnline -Force
}

$AzureCred =  Get-Credential
Connect-AzureAD -Credential $AzureCred
$AzureUser = $AzureTextbox.Text
# Get-AzureADUser -ObjectId $AzureUser |Select-Object *
# Get-AzureADUserLicenseDetail -ObjectId $AzureUser
$Global:MembershipTitle = "GROUP MEMBERSHIPS"
$Global:Memberships = Get-AzureADUserMembership -ObjectId $AzureUser -All $true | Format-List DisplayName | out-string
Connect-MsolService -Credential $AzureCred
$Global:LastPassword = Get-MsolUser -UserPrincipalName $AzureUser | Select LastPasswordChangeTimestamp | out-string 
$Global:License = Get-MsolUser -UserPrincipalName $AzureUser | Format-List DisplayName,Licenses | out-string

AzureOut
}

#region Generated Form Code
$AzureForm.text= "Azure Lookup"
$AzureForm.name= "AzureLookUp"
$AzureForm.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 280
$System_Drawing_Size.Height = 100
$AzureForm.ClientSize = $System_Drawing_Size
$AzureForm.StartPosition = "CenterScreen"

$AzureTextBoxLabel.Text= "Enter Azure User"


$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 40
$System_Drawing_Point.Y = 10
$AzureTextBoxLabel.Width = 200
$AzureTextBoxLabel.Height = 20
$AzureTextBoxLabel.Location = $System_Drawing_Point
$AzureTextBoxLabel.DataBindings.DefaultDataSourceUpdateMode = 0
$AzureForm.Controls.Add($AzureTextBoxLabel)

$AzureTextbox = New-Object System.Windows.Forms.TextBox 
$AzureTextbox.Location = New-Object System.Drawing.Size(40,40) 
$AzureTextbox.Width = 200
$AzureTextbox.Height = 20
$AzureForm.Controls.Add($AzureTextbox)


$AzureLookUpButton.name = "Lookup User Properties"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 200
$System_Drawing_Size.Height = 23
$AzureLookUpButton.Size = $System_Drawing_Size
$AzureLookUpButton.UseVisualStyleBackColor = $True

$AzureLookUpButton.Text = "Lookup"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 40
$System_Drawing_Point.Y = 70
$AzureLookupButton.Location = $System_Drawing_Point
$AzureLookupButton.DataBindings.DefaultDataSourceUpdateMode = 0
$AzureLookupButton.add_Click($handler_AzureLookupButton_Click)

$AzureForm.Controls.Add($AzureLookUpButton)

#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $AzureForm.WindowState
#Init the OnLoad event to correct the initial state of the form
$AzureForm.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$AzureForm.ShowDialog()| Out-Null
}