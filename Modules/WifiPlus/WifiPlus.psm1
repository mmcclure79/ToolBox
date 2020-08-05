#Generated Form Function
function WifiPlus {

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname(“System.Windows.Forms”) | Out-Null
[reflection.assembly]::loadwithpartialname(“System.Drawing”) | Out-Null
#endregion

#region Generated Form Objects
$WiFiForm = New-Object System.Windows.Forms.Form
$ProfileNameLabel = New-Object System.Windows.Forms.Label
$ProfilePswdLabel = New-Object System.Windows.Forms.Label
$ProfileName = New-Object System.Windows.Forms.TextBox
$SecureKey = New-Object System.Windows.Forms.MaskedTextBox
$AddWiFiButton = New-Object System.Windows.Forms.Button
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
$Icon = New-Object system.drawing.icon ("$ToolboxRoot\Modules\wifiplus\Wifi+.ico");
$WiFiForm.Icon = $Icon;
#endregion Generated Form Objects

#———————————————-
#Generated Event Script Blocks
#———————————————-
#Provide Custom Code for events specified in PrimalForms.
$handler_AddWiFiButton_Click=
{
$NameConversion = $ProfileName.Text | ConvertTo-SecureString -AsPlainText -Force 
$PnameConversion = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($NameConversion)
$ProfileNameConversion = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($PnameConversion)
$wSecureKey = $SecureKey.Text | ConvertTo-SecureString -AsPlainText -Force 
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($wSecureKey)
$Key = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

#endregion ConfigurationBlock

$conversionValue = $ProfileNameConversion.ToCharArray()
#Converts the Provided profile to a char array that is then used to convert to Hex.
foreach($letter in $conversionValue){$HexKey = $HexKey + " " + [System.String]::Format("{0:X}", [System.Convert]::ToUInt32($letter))}
#Converts the string into a HEX value
$HexKey = $HexKey.ToSTring()
#Converts the bytecollection object to a String
$HexKey = $HexKey.replace(' ','')
#removes spaces from the string.
$data = @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
	<name>$ProfileNameConversion</name>
	<SSIDConfig>
		<SSID>
			<hex>$HexKey</hex>
			<name>$ProfileNameConversion</name>
		</SSID>
	</SSIDConfig>
	<connectionType>ESS</connectionType>
	<connectionMode>auto</connectionMode>
	<MSM>
		<security>
			<authEncryption>
				<authentication>WPA2PSK</authentication>
				<encryption>AES</encryption>
				<useOneX>false</useOneX>
			</authEncryption>
			<sharedKey>
				<keyType>passPhrase</keyType>
				<protected>false</protected>
				<keyMaterial>$Key</keyMaterial>
			</sharedKey>
		</security>
	</MSM>
	<MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3">
		<enableRandomization>false</enableRandomization>
	</MacRandomization>
</WLANProfile>
"@
#Generates the Here string for a common wifi profile type.
New-Item c:\temp\WLANProfile.xml -ItemType file -Force -Value $data | Out-Null
#Creates the .XML file that will be used to import the profile temporarily.

#Generates the XML file locally in the TEMP directory this can be changed to use a different location.
# start-process netsh ('wlan add profile filename="c:\temp\WLANProfile.xml" user="all"')
$XMLResults = netsh wlan add profile filename="c:\temp\WLANProfile.xml" user="all" | Out-String
[System.Windows.forms.MessageBox]::Show($XMLResults)
Remove-Item c:\temp\WLANProfile.xml | out-null
}

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
$WiFiForm.WindowState = $InitialFormWindowState
}

#———————————————-
#region Generated Form Code
$WiFiForm.Text = “WiFi+”
$WiFiForm.Name = “WiFiForm”
$WiFiForm.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 265
$System_Drawing_Size.Height = 100
$WiFiForm.ClientSize = $System_Drawing_Size
$WiFiForm.StartPosition = "CenterScreen"



$AddWiFiButton.TabIndex = 3
$AddWiFiButton.Name = “AddWiFiButton”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 240
$System_Drawing_Size.Height = 23
$AddWiFiButton.Size = $System_Drawing_Size
$AddWiFiButton.UseVisualStyleBackColor = $True

$AddWiFiButton.Text = “Add WiFi”

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 10
$System_Drawing_Point.Y = 70
$AddWiFiButton.Location = $System_Drawing_Point
$AddWiFiButton.DataBindings.DefaultDataSourceUpdateMode = 0
$AddWiFiButton.add_Click($handler_AddWiFiButton_Click)

$WiFiForm.Controls.Add($AddWiFiButton)

$ProfileNameLabel.Name = "WifiName"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 23
$ProfileNameLabel.Size = $System_Drawing_Size

$ProfileNameLabel.Text = "Wifi SSID"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 10
$System_Drawing_Point.Y = 10
$ProfileNameLabel.Location = $System_Drawing_Point
$ProfileNameLabel.DataBindings.DefaultDataSourceUpdateMode = 0
$WiFiForm.Controls.Add($ProfileNameLabel)


$ProfilePswdLabel.Name = "WifiPswd"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 23
$ProfilePswdLabel.Size = $System_Drawing_Size

$ProfilePswdLabel.Text = "Password"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 125
$System_Drawing_Point.Y = 10
$ProfilePswdLabel.Location = $System_Drawing_Point
$ProfilePswdLabel.DataBindings.DefaultDataSourceUpdateMode = 0
$WiFiForm.Controls.Add($ProfilePswdLabel)

$ProfileName.TabIndex = 1
$ProfileName.Name = "WifiSSID"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 100
$System_Drawing_Size.Height = 23
$ProfileName.Size = $System_Drawing_Size

# $ProfileName.Text = "Enter SSID"

$ProfileNameLabel.Text = "Wifi SSID"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 10
$System_Drawing_Point.Y = 40
$ProfileName.Location = $System_Drawing_Point
$ProfileName.DataBindings.DefaultDataSourceUpdateMode = 0
$WiFiForm.Controls.Add($ProfileName)

$SecureKey.TabIndex = 2
$SecureKey.Name = "SecureKey"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 100
$System_Drawing_Size.Height = 23
$SecureKey.Size = $System_Drawing_Size

# $SecureKey.Text = "Enter Password"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 125
$System_Drawing_Point.Y = 40
$SecureKey.Location = $System_Drawing_Point
$SecureKey.DataBindings.DefaultDataSourceUpdateMode = 0
$WiFiForm.Controls.Add($SecureKey)

#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $WiFiForm.WindowState
#Init the OnLoad event to correct the initial state of the form
$WiFiForm.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$WiFiForm.ShowDialog()| Out-Null

}

