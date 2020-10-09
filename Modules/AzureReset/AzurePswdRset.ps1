# Azure Password Reset. Resets to random generated password and makes user change when they login

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
#endregion

#region Generated Form Objects
$GUI = New-Object System.Windows.Forms.Form
$GUITextBox1 = New-Object System.Windows.Forms.TextBox 
$GuiTextBoxLabel = New-Object System.Windows.Forms.Label
$AzureResetButton = New-Object System.Windows.Forms.Button
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
$ADForm = New-Object System.Windows.Forms.Form
$AzureResetTextBox1 = New-Object System.Windows.Forms.TextBox 
$InitialADFormWindowState = New-Object System.Windows.Forms.FormWindowState

#endregion Generated Form Objects

#———————————————-
#Generated Event Script Blocks
#———————————————-
#Provide Custom Code for events specified in PrimalForms.
$handler_AzureResetButton_Click=
{


function Get-RandomCharacters($length, $characters) {
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    $private:ofs=""
    return [String]$characters[$random]
}
 
function Scramble-String([string]$inputString){     
    $characterArray = $inputString.ToCharArray()
    $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     
    $outputString = -join $scrambledStringArray
    return $outputString 
}

 
$password = Get-RandomCharacters -length 5 -characters 'abcdefghiklmnoprstuvwxyz'
$password += Get-RandomCharacters -length 1 -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
$password += Get-RandomCharacters -length 1 -characters '1234567890'
$password += Get-RandomCharacters -length 1 -characters '!$%&/\~()=?@#*+'
 
 
$password = Scramble-String $password

$user = $AzureResetTextbox1.Text | Out-String
Connect-MsolService
Set-MsolUserPassword -UserPrincipalName $User -NewPassword $password

[System.Windows.forms.MessageBox]::Show("Temporary Password is " + $password)

}

#region Generated Form Code
$GUI.Text = "Reset Azure Password"
$GUI.Name = "AzureReset"
$GUI.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 280
$System_Drawing_Size.Height = 100
$GUI.ClientSize = $System_Drawing_Size
$GUI.StartPosition = "CenterScreen"

$GuiTextBoxLabel.Text = "Enter Azure ID"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 40
$System_Drawing_Point.Y = 10
$GuiTextBoxLabel.Width = 200
$GuiTextBoxLabel.Height = 20
$GuiTextBoxLabel.Location = $System_Drawing_Point
$GuiTextBoxLabel.DataBindings.DefaultDataSourceUpdateMode = 0
$GUI.Controls.Add($GuiTextBoxLabel)


$AzureResetTextbox1 = New-Object System.Windows.Forms.TextBox 
$AzureResetTextbox1.Location = New-Object System.Drawing.Size(40,40) 
$AzureResetTextbox1.Width = 200
$AzureResetTextbox1.Height = 20
$GUI.Controls.Add($AzureResetTextbox1)

$AzureResetButton.Text = "Reset Azure Password"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 40
$System_Drawing_Point.Y = 70
$AzureResetButton.Width = 200
$AzureResetButton.Height = 20
$AzureResetButton.Location = $System_Drawing_Point
$AzureResetButton.DataBindings.DefaultDataSourceUpdateMode = 0
$AzureResetButton.add_Click($handler_AzureResetButton_Click)

$GUI.Controls.Add($AzureResetButton)
#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $GUI.WindowState
#Init the OnLoad event to correct the initial state of the form
$GUI.add_Load($OnLoadFormGUI_StateCorrection)
#Show the Form
$GUI.ShowDialog()| Out-Null