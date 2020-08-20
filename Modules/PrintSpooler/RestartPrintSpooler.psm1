function PrintSpoolerRestart

{
$PRStart = Restart-Service -Name Spooler | Out-string
[System.Windows.forms.MessageBox]::Show("service 'Print Spooler (Spooler)' has restarted.")
}