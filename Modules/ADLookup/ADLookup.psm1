Function ADLookup 
{
#region Import the Assemblies
[reflection.assembly]::loadwithpartialname(“System.Windows.Forms”) | Out-Null
[reflection.assembly]::loadwithpartialname(“System.Drawing”) | Out-Null
#End Region

#region Generated Form Objects
$GUI = New-Object System.Windows.Forms.Form
$GUITextBox1 = New-Object System.Windows.Forms.TextBox 
$GuiTextBoxLabel = New-Object System.Windows.Forms.Label
$ADLookupButton = New-Object System.Windows.Forms.Button
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
$ADForm = New-Object System.Windows.Forms.Form
$ADTextBox = New-Object System.Windows.Forms.TextBox 
$InitialADFormWindowState = New-Object System.Windows.Forms.FormWindowState

#endregion Generated Form Objects

#———————————————-
#Generated Event Script Blocks
#———————————————-
#Provide Custom Code for events specified in PrimalForms.
$handler_ADLookUpButton_Click=
{
$UNAME = $GUITextbox1.Text | Out-String -AsPlainText
$NetUser = Net user $UNAME /domain | Out-String
$GetAD = Get-ADUser $UNAME -Properties * | Out-String
# Uncomment the following for testing of data Presentation
# $NetUser = [IO.File]::ReadAllText(".\net user out.txt")
# $GetAD = [IO.File]::ReadAllText(".\getaduser.txt")
write-host = $uname
$ADForm.Text = “AD Results”
$ADForm.Name = “ADResults”
$ADForm.DataBindings.DefaultDataSourceUpdateMode = 0
$ADSystem_Drawing_Size = New-Object System.Drawing.Size
$ADSystem_Drawing_Size.Width = 300
$ADSystem_Drawing_Size.Height = 440
$ADForm.ClientSize = $ADSystem_Drawing_Size
$ADForm.StartPosition = "CenterScreen"


$ADText = New-Object System.Windows.Forms.RichTextBox 
$ADText.Location = New-Object System.Drawing.Size(0,0) 
$ADText.Width = $ADSystem_Drawing_Size.Width
$ADText.Height = $ADSystem_Drawing_Size.Height
$ADForm.Controls.Add($ADText)


#Save the initial state of the form
$InitialADFormWindowState = $ADForm.WindowState
#Init the OnLoad event to correct the initial state of the form
$ADForm.add_Load($OnLoadFormAD_StateCorrection)
#Show the Form
$ADForm.ShowDialog()| Out-Null
}

#region Generated Form Code
$GUI.Text = “AD Lookup”
$GUI.Name = “ADLookup”
$GUI.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 280
$System_Drawing_Size.Height = 100
$GUI.ClientSize = $System_Drawing_Size
$GUI.StartPosition = "CenterScreen"

$GuiTextBoxLabel.Text = "Enter Domain Username"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 40
$System_Drawing_Point.Y = 10
$GuiTextBoxLabel.Width = 200
$GuiTextBoxLabel.Height = 20
$GuiTextBoxLabel.Location = $System_Drawing_Point
$GuiTextBoxLabel.DataBindings.DefaultDataSourceUpdateMode = 0
$GUI.Controls.Add($GuiTextBoxLabel)


$GUITextbox1 = New-Object System.Windows.Forms.TextBox 
$GUITextbox1.Location = New-Object System.Drawing.Size(40,40) 
$GUITextbox1.Width = 200
$GUITextbox1.Height = 20
$GUI.Controls.Add($GUITextbox1)

$ADLookupButton.Text = “Lookup User Properties”

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 40
$System_Drawing_Point.Y = 70
$ADLookupButton.Width = 200
$ADLookupButton.Height = 20
$ADLookupButton.Location = $System_Drawing_Point
$ADLookupButton.DataBindings.DefaultDataSourceUpdateMode = 0
$ADLookupButton.add_Click($handler_ADLookupButton_Click)

$GUI.Controls.Add($ADLookupButton)
#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $GUI.WindowState
#Init the OnLoad event to correct the initial state of the form
$GUI.add_Load($OnLoadFormGUI_StateCorrection)
#Show the Form
$GUI.ShowDialog()| Out-Null
}


