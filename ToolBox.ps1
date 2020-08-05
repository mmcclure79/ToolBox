﻿function RunAsAdmin
{
# Get the ID and security principal of the current user account
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent();
$myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID);

# Get the security principal for the administrator role
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator;

# Check to see if we are currently running as an administrator
if ($myWindowsPrincipal.IsInRole($adminRole))
{
    # We are running as an administrator, so change the title and background colour to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)";
    $Host.UI.RawUI.BackgroundColor = "DarkBlue";
    Clear-Host;
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
<system.windows.forms jitDebugging="true" />
#endregion

#region Generated Form Objects
$ToolBoxForm = New-Object System.Windows.Forms.Form
$AddWiFiButton = New-Object System.Windows.Forms.Button
$ADLookupButton = New-Object System.Windows.Forms.Button
$RestartSpoolerButton = New-Object System.Windows.Forms.Button
$WifiBounceButton = New-Object System.Windows.Forms.Button
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
$System_Drawing_Size.Width = 400
$System_Drawing_Size.Height = 100
$ToolBoxForm.ClientSize = $System_Drawing_Size
$ToolBoxForm.StartPosition = "CenterScreen"

#ADLookup Button
$ADLookupButton.Name = “AddWiFiButton”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 150
$System_Drawing_Size.Height = 23
$ADLookupButton.Size = $System_Drawing_Size
$ADLookupButton.UseVisualStyleBackColor = $True

$ADLookupButton.Text = “AD Lookup”

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 10
$System_Drawing_Point.Y = 10
$ADLookupButton.Location = $System_Drawing_Point
$ADLookupButton.DataBindings.DefaultDataSourceUpdateMode = 0
$ADLookupButton.add_Click($handler_ADLookupButton_Click)

$ToolBoxForm.Controls.Add($ADLookupButton)
#End ADLookup BUtton

#AddWifi Button$AddWiFiButton.Name = “AddWiFiButton”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 150
$System_Drawing_Size.Height = 23
$AddWiFiButton.Size = $System_Drawing_Size
$AddWiFiButton.UseVisualStyleBackColor = $True

$AddWiFiButton.Text = “Add WiFi”

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 10
$System_Drawing_Point.Y = 35
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
$System_Drawing_Point.X = 10
$System_Drawing_Point.Y = 60
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
$System_Drawing_Point.Y = 10
$RestartSpoolerButton.Location = $System_Drawing_Point
$RestartSpoolerButton.DataBindings.DefaultDataSourceUpdateMode = 0
$RestartSpoolerButton.add_Click($handler_RestartSpoolerButton_Click)

$ToolBoxForm.Controls.Add($RestartSpoolerButton)
#End Print Spooler BUtton

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
