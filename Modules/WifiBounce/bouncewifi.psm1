Function WifiBounce()
{
[reflection.assembly]::loadwithpartialname(“System.Windows.Forms”)
[reflection.assembly]::loadwithpartialname(“System.Drawing”)
$NIC = get-wmiobject win32_networkadapter -filter "netconnectionstatus = 2" | select netconnectionid, netconnectionstatus
[System.Windows.forms.MessageBox]::Show("Click OK to disable " + $NIC.netconnectionid)
$wifi = (get-netconnectionProfile).Name
netsh interface set interface $NIC.netconnectionid DISABLED
[System.Windows.forms.MessageBox]::Show("Click OK to Reconnect to " + $wifi)
netsh interface set interface $NIC.netconnectionid ENABLED 
$LiveWifi = netsh wlan connect name=$wifi | Out-String
[System.Windows.forms.MessageBox]::Show($LiveWifi)

}
