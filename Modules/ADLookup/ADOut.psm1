function ADOutput
{
#region Import the Assemblies
[reflection.assembly]::loadwithpartialname(“System.Windows.Forms”) | Out-Null
[reflection.assembly]::loadwithpartialname(“System.Drawing”) | Out-Null
#End Region

#region Generated Form Objects
$ADForm = New-Object System.Windows.Forms.Form
$ADTextBox = New-Object System.Windows.Forms.TextBox 
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

#endregion Generated Form Objects


#region Generated Form Code
$ADForm.Text = “AD Results”
$ADForm.Name = “ADResults”
$ADForm.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 280
$System_Drawing_Size.Height = 440
$ADForm.ClientSize = $System_Drawing_Size
$ADForm.StartPosition = "CenterScreen"


$ADTextBox = New-Object System.Windows.Forms.TextBox 
$ADTextBox.Location = New-Object System.Drawing.Size(10,10) 
$ADTextBox.Multiline = $True
$ADTextBox.ScrollBars = "Both"
$ADTextBox.WordWrap = $True
$ADTextBox.Width = 200
$ADTextBox.Height = 400
$ADTextBox.Text = $NETUSER + $GETAD
$ADForm.Controls.Add($ADTextBox)


#Save the initial state of the form
$InitialFormWindowState = $ADForm.WindowState
#Init the OnLoad event to correct the initial state of the form
$ADForm.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$ADForm.ShowDialog()| Out-Null
}