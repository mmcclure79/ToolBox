Function WifiBounce()
{
[reflection.assembly]::loadwithpartialname(“System.Windows.Forms”)
[reflection.assembly]::loadwithpartialname(“System.Drawing”)
$NIC = get-wmiobject win32_networkadapter -filter "netconnectionstatus = 2" | select netconnectionid, netconnectionstatus
$wifi = (get-netconnectionProfile).Name
[System.Windows.forms.MessageBox]::Show("Click OK to disable " + $NIC.netconnectionid + " and reconnect to " + $wifi)
netsh interface set interface $NIC.netconnectionid DISABLED
netsh interface set interface $NIC.netconnectionid ENABLED 
$LiveWifi = netsh wlan connect name=$wifi | Out-String
[System.Windows.forms.MessageBox]::Show($LiveWifi)

}
