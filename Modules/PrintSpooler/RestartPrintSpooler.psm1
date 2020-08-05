function PrintSpoolerRestart

{

Import-Module $ToolboxRoot\RunAsAdmin.psm1
RunAsAdmin

$PRStart = Restart-Service -Name Spooler | Out-string
[System.Windows.forms.MessageBox]::Show($PRStart)
}