function AzureOut
{
#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
#End Region

#region Generated Form Objects
$AzureForm = New-Object System.Windows.Forms.Form
$AzureTextBox = New-Object System.Windows.Forms.TextBox 
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

#endregion Generated Form Objects


#region Generated Form Code
$AzureForm.Text = "Azure Results"
$AzureForm.Name = "AzureResults"
$AzureForm.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 280
$System_Drawing_Size.Height = 440
$AzureForm.ClientSize = $System_Drawing_Size
$AzureForm.StartPosition = "CenterScreen"


$AzureTextBox = New-Object System.Windows.Forms.TextBox 
$AzureTextBox.Location = New-Object System.Drawing.Size(10,10) 
$AzureTextBox.Multiline = $True
$AzureTextBox.ScrollBars = "Both"
$AzureTextBox.WordWrap = $true
$AzureTextBox.Width = 260
$AzureTextBox.Height = 420
$AzureTextBox.readonly = $True
$AzureTextBox.Text = $MembershipTitle + $Memberships + $LastPassword + $License
$AzureForm.Controls.Add($AzureTextBox)


#Save the initial state of the form
$InitialFormWindowState = $AzureForm.WindowState
#Init the OnLoad event to correct the initial state of the form
$AzureForm.add_Load($OnLoAzureForm_StateCorrection)
#Show the Form
$AzureForm.ShowDialog()| Out-Null
}