function RunAsAdmin {
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
Function SysInfo {
$wsh = New-Object -ComObject Wscript.Shell
$wsh.popup("Getting System Information",2,"",0)
$GLOBAL:Start = $((Get-Date).ToString())
$GLOBAL:BootTime = (Get-CimInstance -class Win32_OperatingSystem).LastBootUpTime
$GLOBAL:CPUName = (Get-CimInstance -class cim_processor).name
$GLOBAL:Processor = Get-CimInstance -ClassName 'Win32_Processor' ` | Measure-Object -Property 'NumberOfCores' -Sum
$GLOBAL:OSName = (Get-CimInstance -class Win32_OperatingSystem).Caption
$GLOBAL:OSVer = (Get-CimInstance -class Win32_OperatingSystem).BuildNumber
$GLOBAL:OSDir = (Get-CimInstance -class Win32_OperatingSystem).SystemDirectory
$GLOBAL:OSKey = (Get-CimInstance -class softwarelicensingservice).OA3xOriginalProductKey

$GLOBAL:SYSBrand = (Get-CimInstance -class win32_bios).Manufacturer
$GLOBAL:SYSModel = (Get-CimInstance -Class Win32_ComputerSystem).Model
$GLOBAL:BIOSVer = (Get-CimInstance -class win32_bios).name
$LatestUpdates = gwmi win32_quickfixengineering |sort installedon -desc | Out-string
$GLOBAL:Updates = $LatestUpdates
#.HotFixID
$GLOBAL:ServiceTag = (Get-CimInstance -class win32_bios).SerialNumber
$GLOBAL:CompName = hostname
}
Function NetStat {
$wsh = New-Object -ComObject Wscript.Shell
$wsh.popup("Getting Network Information",2,"",0)

#Replace the Download URL to where you've uploaded the ZIP file yourself. We will only download this file once. 
#Latest version can be found at: https://www.speedtest.net/nl/apps/cli
$DownloadURL = "https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-win64.zip"
$DownloadLocation = "$($Env:ProgramData)\SpeedtestCLI"
try {
    $TestDownloadLocation = Test-Path $DownloadLocation
    if (!$TestDownloadLocation) {
        new-item $DownloadLocation -ItemType Directory -force | Out-Null
        Invoke-WebRequest -Uri $DownloadURL -OutFile "$($DownloadLocation)\speedtest.zip" | Out-Null
        Expand-Archive "$($DownloadLocation)\speedtest.zip" -DestinationPath $DownloadLocation -Force
    } 
}
catch {  
    $UTIME = (Get-CimInstance -class Win32_OperatingSystem).LastBootUpTime
$wsh = New-Object -ComObject Wscript.Shell
$wsh.popup($UTIME,5,"The download and extraction of SpeedtestCLI failed. Error: $($_.Exception.Message)",48)
    exit 1
}
$GLOBAL:SpeedtestResults = & "$($DownloadLocation)\speedtest.exe" --format=json --accept-license --accept-gdpr
$GLOBAL:SpeedtestResults | Out-File "$($DownloadLocation)\LastResults.txt" -Force
$GLOBAL:SpeedtestResults = $SpeedtestResults | ConvertFrom-Json
 
#creating object
[PSCustomObject]$GLOBAL:SpeedtestObj = @{
    downloadspeed = [math]::Round($SpeedtestResults.download.bandwidth / 1000000 * 8, 2)
    uploadspeed   = [math]::Round($SpeedtestResults.upload.bandwidth / 1000000 * 8, 2)
    packetloss    = [math]::Round($SpeedtestResults.packetLoss)
    isp           = $SpeedtestResults.isp
    ExternalIP    = $SpeedtestResults.interface.externalIp
    InternalIP    = $SpeedtestResults.interface.internalIp
    UsedServer    = $SpeedtestResults.server.host
    ResultsURL    = $SpeedtestResults.result.url
    Jitter        = [math]::Round($SpeedtestResults.ping.jitter)
    Latency       = [math]::Round($SpeedtestResults.ping.latency)
}
if ($SpeedtestObj.jitter -lt 30)
{$GLOBAL:JitterRate = "Jitter rate within range for VOIP"
}
else 
{$GLOBAL:JitterRate = "Jitter rate beyond range for VOIP"
}
if ($SpeedtestObj.Latency -lt 150)
{
$GLOBAL:LateRate = "Latency is within range for VOIP"
}
else
{
$GLOBAL:LateRate = "Latency is beyond range for VOIP"
}
if ($Speed.packetloss -lt 1)
{
$GLOBAL:PacketRate = "Packet Loss is within range for VOIP"
}
else{
$GLOBAL:PacketRate = "Packet Loss is beyond range for VOIP"
}
$GLOBAL:GeoInfo = Invoke-RestMethod -uri "http://ipinfo.io"

Remove-Item -Recurse -Force $DownloadLocation
}
Function RAM {
$wsh = New-Object -ComObject Wscript.Shell
$wsh.popup("Getting Memory Information",2,"",0)

#Memory Status
$GLOBAL:Ram = (Get-CimInstance -Class Win32_PhysicalMemory).capacity
$GLOBAL:AvailRam = ($Ram | measure-Object -sum).sum / 1gb
$GLOBAL:RamFree = [math]::truncate((Get-CimInstance -Class win32_operatingsystem).FreePhysicalMemory / 1MB)
$GLOBAL:Banks = (Get-CimInstance -Class Win32_PhysicalMemoryArray).MemoryDevices
$GLOBAL:MAXRAM = (Get-CimInstance -Class Win32_PhysicalMemoryArray).Maxcapacity / 1MB
$GLOBAL:RAMLocation = (Get-CimInstance -Class Win32_PhysicalMemory).DeviceLocator
$GLOBAL:RamSpeed = (Get-CimInstance -Class Win32_PhysicalMemory).Speed
}
Function Disk {
$wsh = New-Object -ComObject Wscript.Shell
$wsh.popup("Getting Local Disk Information",2,"",0)

#Get Disk Size and Space
$GLOBAL:SystemDrive = Get-CimInstance -Class Win32_logicaldisk -filter "DeviceID='C:'"
$GLOBAL:LocalDrives = Get-CimInstance -Class Win32_logicaldisk -Filter "DriveType = '3'"
$GLOBAL:Capacity = [math]::truncate($SystemDrive.Size / 1GB)
$GLOBAL:FreeSpace = [math]::truncate($SystemDrive.Freespace / 1GB)

#Get Disk Speed
$DownloadURL = "https://github.com/Microsoft/diskspd/releases/download/v2.0.21a/DiskSpd-2.0.21a.zip"
Invoke-WebRequest -Uri $DownloadURL -OutFile "C:\Windows\Temp\diskspd.zip"
Expand-Archive "C:\Windows\Temp\diskspd.zip" -force
move-item .\diskspd\AMD64\Diskspd.exe .\Diskspd.exe -force
Remove-Item -force C:\Windows\Temp\diskspd.zip

$Test = .\Diskspd.exe -b128K -d10 -o8 -t2 -w50 -L -c1M -si C:\io.dat
$GLOBAL:ReadResults = $Test[-30] | convertfrom-csv -Delimiter "|" -Header Bytes,IO,Mib,IOPS,File,Latency | Select-Object IO,MIB,IOPs,Latency
$GLOBAL:WriteResults = $Test[-22] | convertfrom-csv -Delimiter "|" -Header Bytes,IO,Mib,IOPS,File,Latency | Select-Object IO,MIB,IOPS,Latency
$GLOBAL:Results = $Test[-9] | convertfrom-csv -Delimiter "|" -Header %-ile,Read,Write,Total | Select-Object Read,Write,Total
if ($Results.total -le 1)
{$GLOBAL:DriveSpeed = "Drive Speeds are Excellent"}
else
{if ($Results.total -le 5)
{$GLOBAL:DriveSpeed = "Drive Speeds are Very Good"}
else
{if ($Results.total -le 10)
{$GLOBAL:DriveSpeed = "Drive Speeds are Good"}
else
{$GLOBAL:DriveSpeed = "Drive Speeds are GARBAGE"}
}
}
Remove-Item diskspd.exe
Remove-Item -Recurse -Force diskspd 
}
function SysOutput {
#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
#End Region

#region Generated Form Objects
$SysForm = New-Object System.Windows.Forms.Form
$SysText = New-Object System.Windows.Forms.TextBox 
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

#endregion Generated Form Objects


#region Generated Form Code
$SysForm.Text = "Performance Results"
$SysForm.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 590
$System_Drawing_Size.Height = 640
$SysForm.ClientSize = $System_Drawing_Size
$SysForm.StartPosition = "CenterScreen"


$SysText = New-Object System.Windows.Forms.TextBox 
$SysText.Location = New-Object System.Drawing.Size(10,10) 
$SysText.Multiline = $True
$sysText.AcceptsReturn = $True
$SysText.ScrollBars = "Both"
$SysText.WordWrap = $True
$SysText.Width = 550
$SysText.Height = 600
$SysText.readonly = $True
$SysText.Text = "SYSTEM INFORMATION 
Computer Name: " + $Compname + "
System Last Booted: " + $BootTime + "
System Processor: " + $Processor.sum + " Core, " + $CPUName + "
OS:" + $OSName + "Build " + $OSVer + "
Windows System Directory: " + $OSDir + "
Original Windows Key: " + $OSKey + "
System: " + $SYSBrand + $SYSModel + " Service Tag - " + $ServiceTag + "
System BIOS Version: " + $BIOSVer + "
Latest Windows Updates " + $Updates + "
PHYSICAL DRIVE RESULTS " + "
Local Drives: " + $LocalDrives.deviceID + "
System Drive: " + $SystemDrive.deviceID + "
Drive Capacity (GB) " + $Capacity + "
Free space (GB) " + $FreeSpace + "
Read Speeds " + $ReadResults + "
Write Speeds " + $WriteResults + "
" +
$DriveSpeed + "

MEMORY DETAILS" + "
# of Banks: " + $Banks + "
Max RAM System can handle: " + $MAXRAM + "
Banks Filled: " + $RAMLocation + "
Ram Speed: " + $RamSpeed + "
Total Memory (GB): " + $AvailRam + "
Available Memory (GB): " + $RamFree + "

INTERNET QUALITY" + "
Internal IP: " + $SpeedtestObj.InternalIP + "
Public IP: " + $GeoInfo.ip + "
Internet Provider: " + $GeoInfo.org + "
Location: " + $GeoInfo.loc + " in " + $GeoInfo.city + $GeoInfo.region + "," + $GeoInfo.postal + "
Download (MB): " + $SpeedtestObj.downloadspeed + "
Upload (MB): " + $SpeedtestObj.uploadspeed + "
Test Server Used: " + $SpeedtestObj.UsedServer + "
"+
$PacketRate + ", Packet Loss:" + $SpeedtestObj.packetLoss + "
"+
$LateRate + ", Latency:" + $SpeedtestObj.latency + "
"+
$JitterRate +", Jitter:" + $SpeedtestObj.jitter 
$SysForm.Controls.Add($SysText)


#Save the initial state of the form
$InitialFormWindowState = $SysForm.WindowState
#Init the OnLoad event to correct the initial state of the form
$SysForm.add_Load($OnLoSysForm_StateCorrection)
#Show the Form
$SysForm.ShowDialog()| Out-Null
}