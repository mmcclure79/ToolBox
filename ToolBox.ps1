if ((get-host).version.major -lt 5)
{
$wsh = New-Object -ComObject Wscript.Shell
$wsh.popup("Powershell is less than v.5 Not everything is guaranteed to work.",5,"Powershell Warning",48)
}
if ((Get-CimInstance -class Win32_OperatingSystem).BuildNumber -lt 18363)
{
$wsh = New-Object -ComObject Wscript.Shell
$wsh.popup("Not running Windows 10, Build 18363 Not everything is guaranteed to work.",5,"Windows Warning",48)
}

function RunAsAdmin
{
# Get the ID and security principal of the current user account
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent();
$myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID);

# Get the security principal for the administrator role
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator;

# Check to see if we are currently running as an administrator
if ($myWindowsPrincipal.IsInRole($adminRole))
{
    # We are running as an administrator, so keep going. This is a GUI so no cli windows needed.
}
else {
    # We are not running as an administrator, so relaunch as administrator

    # Create a new process object that starts PowerShell
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";

    # Specify the current script path and name as a parameter with added scope and support for scripts with spaces in it's path
    $newProcess.Arguments = "& '" + $script:MyInvocation.MyCommand.Path + "'"

    # Indicate that the process should be elevated
    $newProcess.Verb = "runas";

    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess);

    # Exit from the current, unelevated, process
    Exit;
}
}

runasadmin

# No shell window
$t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
add-type -name win -member $t -namespace native
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0)
$Global:ToolboxRoot = split-path -parent $MyInvocation.MyCommand.Definition

#Generated Form Function
function ToolBox {

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname(“System.Windows.Forms”) | Out-Null
[reflection.assembly]::loadwithpartialname(“System.Drawing”) | Out-Null
#<system.windows.forms jitDebugging="true" />
#endregion

#region Generated Form Objects
$ToolBoxForm = New-Object System.Windows.Forms.Form
$AddWiFiButton = New-Object System.Windows.Forms.Button
$ADLookupButton = New-Object System.Windows.Forms.Button
$RestartSpoolerButton = New-Object System.Windows.Forms.Button
$SysUpTimeButton = New-Object System.Windows.Forms.Button
$WifiBounceButton = New-Object System.Windows.Forms.Button
$AzureLookupButton = New-Object System.Windows.Forms.Button
$SysStatButton = New-Object System.Windows.Forms.Button
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
$Icon = New-Object system.drawing.icon ("$ToolboxRoot\Toolbox.ico");
$ToolBoxForm.Icon = $Icon;
#endregion Generated Form Objects

#———————————————-
#Generated Event Script Blocks
#———————————————-
#Provide Custom Code for events specified in PrimalForms.
$handler_AddWiFiButton_Click=
{
Import-Module $ToolboxRoot\modules\WifiPlus\wifiplus.psm1
wifiplus
export-Module $ToolboxRoot\modules\WifiPlus\wifiplus.psm1
}

$handler_ADLookupButton_Click=
{
Import-Module $ToolboxRoot\modules\ADLookup\ADLookup.psm1
ADLookup
}

$handler_AzureLookupButton_Click =
{
Import-Module $ToolboxRoot\modules\AzureLookup\AzureLookup.psm1
Import-Module $ToolboxRoot\modules\AzureLookup\Out.psm1
AzureLookup
}

$handler_RestartSpoolerButton_Click =
{
Import-Module $ToolboxRoot\modules\PrintSpooler\RestartPrintSPooler.psm1
PrintSpoolerRestart

}

$handler_WiFiBounceButton_Click=
{
Import-Module $ToolboxRoot\modules\WifiBounce\bouncewifi.psm1
wifibounce
export-Module $ToolboxRoot\modules\WifiBounce\bouncewifi.psm1
}

$handler_SysUpTimeButton_Click=
{
$UTIME = (Get-CimInstance -class Win32_OperatingSystem).LastBootUpTime
$wsh = New-Object -ComObject Wscript.Shell
$wsh.popup($UTIME,5,"System Last Booted",48)
#[System.Windows.forms.MessageBox]::Show("System Running since: " +$UTIME)
}
$handler_SysStatButton_Click=
{
Import-Module $ToolboxRoot\modules\SysStats\sysstats.psm1
SysInfo
Disk
RAM
NetStat
SysOutput
}

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
$ToolBoxForm.WindowState = $InitialFormWindowState
}

#———————————————-
#region Generated Form Code
$ToolBoxForm.Text = “Tool Box”
$ToolBoxForm.Name = “ToolBoxForm”
$ToolBoxForm.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 350
$System_Drawing_Size.Height = 150
$ToolBoxForm.ClientSize = $System_Drawing_Size
$ToolBoxForm.StartPosition = "CenterScreen"

#ADLookup Button
$ADLookupButton.Name = “ADLookupButton”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 150
$System_Drawing_Size.Height = 23
$ADLookupButton.Size = $System_Drawing_Size
$ADLookupButton.UseVisualStyleBackColor = $True

$ADLookupButton.Text = “AD User Lookup”

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 10
$System_Drawing_Point.Y = 10
$ADLookupButton.Location = $System_Drawing_Point
$ADLookupButton.DataBindings.DefaultDataSourceUpdateMode = 0
$ADLookupButton.add_Click($handler_ADLookupButton_Click)

$ToolBoxForm.Controls.Add($ADLookupButton)
#End ADLookup BUtton

#AzureLookup Button
$AzureLookupButton.Name = “Azure Lookup Button”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 150
$System_Drawing_Size.Height = 23
$AzureLookupButton.Size = $System_Drawing_Size
$AzureLookupButton.UseVisualStyleBackColor = $True

$AzureLookupButton.Text = “Azure User Lookup”

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 10
$System_Drawing_Point.Y = 33
$AzureLookupButton.Location = $System_Drawing_Point
$AzureLookupButton.DataBindings.DefaultDataSourceUpdateMode = 0
$AzureLookupButton.add_Click($handler_AzureLookupButton_Click)

$ToolBoxForm.Controls.Add($AzureLookupButton)
#End AzureLookup Button


#AddWifi Button$AddWiFiButton.Name = “AddWiFiButton”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 150
$System_Drawing_Size.Height = 23
$AddWiFiButton.Size = $System_Drawing_Size
$AddWiFiButton.UseVisualStyleBackColor = $True

$AddWiFiButton.Text = “Add WiFi”

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 10
$System_Drawing_Point.Y = 55
$AddWiFiButton.Location = $System_Drawing_Point
$AddWiFiButton.DataBindings.DefaultDataSourceUpdateMode = 0
$AddWiFiButton.add_Click($handler_AddWiFiButton_Click)

$ToolBoxForm.Controls.Add($AddWiFiButton)
# End AddWifi Button

#BounceWifi Button
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 150
$System_Drawing_Size.Height = 23
$WiFiBounceButton.Size = $System_Drawing_Size
$WiFiBounceButton.UseVisualStyleBackColor = $True

$WiFiBounceButton.Text = “Bounce WiFi”

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 10
$WiFiBounceButton.Location = $System_Drawing_Point
$WiFiBounceButton.DataBindings.DefaultDataSourceUpdateMode = 0
$WiFiBounceButton.add_Click($handler_WiFiBounceButton_Click)

$ToolBoxForm.Controls.Add($WiFiBounceButton)
# End BounceWifi Button


#Restart Print Spooler Button
$RestartSpoolerButton.Name = “RestartSpooler”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 150
$System_Drawing_Size.Height = 23
$RestartSpoolerButton.Size = $System_Drawing_Size
$RestartSpoolerButton.UseVisualStyleBackColor = $True

$RestartSpoolerButton.Text = “Restart Printers”

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 32
$RestartSpoolerButton.Location = $System_Drawing_Point
$RestartSpoolerButton.DataBindings.DefaultDataSourceUpdateMode = 0
$RestartSpoolerButton.add_Click($handler_RestartSpoolerButton_Click)

$ToolBoxForm.Controls.Add($RestartSpoolerButton)
#End Print Spooler Button

#System Stats Button 
$SysStatButton.Name = “SystemStatus”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 150
$System_Drawing_Size.Height = 23
$SysStatButton.Size = $System_Drawing_Size
$SysStatButton.UseVisualStyleBackColor = $True

$SysStatButton.Text = “System Status”

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 55
$SysStatButton.Location = $System_Drawing_Point
$SysStatButton.DataBindings.DefaultDataSourceUpdateMode = 0
$SysStatButton.add_Click($handler_SysStatButton_Click)

$ToolBoxForm.Controls.Add($SysStatButton)

#End System Stats Button

#System Up Time Button
$SysUpTimeButton.Name = “System UpTime”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 150
$System_Drawing_Size.Height = 23
$SysUpTimeButton.Size = $System_Drawing_Size
$SysUpTimeButton.UseVisualStyleBackColor = $True

$SysUpTimeButton.Text = “System Uptime”

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 78
$SysUpTimeButton.Location = $System_Drawing_Point
$SysUpTimeButton.DataBindings.DefaultDataSourceUpdateMode = 0
$SysUpTimeButton.add_Click($handler_SysUpTimeButton_Click)

$ToolBoxForm.Controls.Add($SysUpTimeButton)
#End Sys UpTime Button


#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $ToolBoxForm.WindowState
#Init the OnLoad event to correct the initial state of the form
$ToolBoxForm.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$ToolBoxForm.ShowDialog()| Out-Null

} #End Function

#Call the Function
ToolBox

