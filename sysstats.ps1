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
Function SysInfo {
$BootTime = (Get-CimInstance -class Win32_OperatingSystem).LastBootUpTime
$CPUName = (Get-CimInstance -class cim_processor).name
$Processor = Get-CimInstance -ClassName 'Win32_Processor' ` | Measure-Object -Property 'NumberOfCores' -Sum
$OSName = (Get-CimInstance -class Win32_OperatingSystem).Caption
$OSVer = (Get-CimInstance -class Win32_OperatingSystem).BuildNumber
$OSDir = (Get-CimInstance -class Win32_OperatingSystem).SystemDirectory
$OSKey = (Get-CimInstance -class softwarelicensingservice).OA3xOriginalProductKey

$SYSBrand = (Get-CimInstance -class win32_bios).Manufacturer
$SYSModel = (Get-CimInstance -Class Win32_ComputerSystem).Model
$BIOSVer = (Get-CimInstance -class win32_bios).name

$ServiceTag = (Get-CimInstance -class win32_bios).SerialNumber
$CompName = hostname
Write-Host 
Write-Host SYSTEM INFORMATION
Write-Host Computer Name:	$Compname
Write-Host System Last Booted: $BootTime
Write-Host System Processor: $Processor.sum Core, $CPUName
Write-Host OS:$OSName Build $OSVer
Write-Host Windows System Directory: $OSDir
Write-Host Original Windows Key: $OSKey
Write-Host System: $SYSBrand $SYSModel Service Tag - $ServiceTag
Write-Host System BIOS Version: $BIOSVer
}
Function NetStat {
Write-Host "INTERNET QUALITY"
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
    write-host "The download and extraction of SpeedtestCLI failed. Error: $($_.Exception.Message)"
    exit 1
}
$SpeedtestResults = & "$($DownloadLocation)\speedtest.exe" --format=json --accept-license --accept-gdpr
$SpeedtestResults | Out-File "$($DownloadLocation)\LastResults.txt" -Force
$SpeedtestResults = $SpeedtestResults | ConvertFrom-Json
 
#creating object
[PSCustomObject]$SpeedtestObj = @{
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
{$JitterRate = "Jitter rate within range for VOIP"
}
else 
{JitterRate = "Jitter rate beyond range for VOIP"
}
if ($SpeedtestObj.Latency -lt 150)
{
$LateRate = "Latency is within range for VOIP"
}
else
{
$LateRate = "Latency is beyond range for VOIP"
}
if ($Speed.packetloss -lt 1)
{
$PacketRate = "Packet Loss is within range for VOIP"
}
else{
$PacketRate = "Packet Loss is beyond range for VOIP"
}
$GeoInfo = Invoke-RestMethod -uri "http://ipinfo.io"


Write-host "Internal IP: " $SpeedtestObj.InternalIP
Write-Host "Public IP: " $GeoInfo.ip
Write-Host "Internet Provider: " $GeoInfo.org
Write-Host "Location: " $GeoInfo.loc " in "$GeoInfo.city $GeoInfo.region, $GeoInfo.postal 
Write-host "Download (MB): "$SpeedtestObj.downloadspeed 
Write-host "Upload (MB): "$SpeedtestObj.uploadspeed 
Write-host "Test Server Used: " $SpeedtestObj.UsedServer 
Write-host $PacketRate", Packet Loss:" $SpeedtestObj.packetLoss 
Write-host $LateRate", Latency:" $SpeedtestObj.latency 
Write-host $JitterRate", Jitter:" $SpeedtestObj.jitter 

Remove-Item -Recurse -Force $DownloadLocation
}
Function RAM{
#Memory Status
$Ram = (Get-CimInstance -Class Win32_PhysicalMemory).capacity / 1GB
$RamFree = [math]::truncate((Get-CimInstance -Class win32_operatingsystem).FreePhysicalMemory / 1MB)
$Banks = (Get-CimInstance -Class Win32_PhysicalMemoryArray).MemoryDevices
$MAXRAM = (Get-CimInstance -Class Win32_PhysicalMemoryArray).Maxcapacity / 1MB
$RAMLocation = (Get-CimInstance -Class Win32_PhysicalMemory).DeviceLocator
$RamSpeed = (Get-CimInstance -Class Win32_PhysicalMemory).Speed
Write-host MEMORY DETAILS

Write-Host "#" of Banks: $Banks
Write-Host Max RAM System can handle: $MAXRAM
Write-Host Banks Filled: $RAMLocation
Write-Host Ram Speed: $RamSpeed
Write-Host Total Memory "(GB)": $RAM
Write-Host Available Memory "(GB)": $RamFree
Write-Host
}
Function Disk {
Write-Host
#Get Disk Size and Space
$DriveSize = Get-CimInstance -Class Win32_logicaldisk -Filter "DriveType = '3'"
$Capacity = [math]::truncate($DriveSize.Size / 1GB)
$FreeSpace = [math]::truncate($DriveSize.Freespace / 1GB)

#Get Number of cores
$Processor = Get-CimInstance -ClassName 'Win32_Processor' ` | Measure-Object -Property 'NumberOfCores' -Sum
$CoreN = $Processor.sum
#Get Disk Speed
$DownloadURL = "https://github.com/Microsoft/diskspd/releases/download/v2.0.21a/DiskSpd-2.0.21a.zip"
Invoke-WebRequest -Uri $DownloadURL -OutFile "C:\Windows\Temp\diskspd.zip"
Expand-Archive "C:\Windows\Temp\diskspd.zip" -force
move-item $PWD\diskspd\AMD64\Diskspd.exe $PWD\Diskspd.exe -force
Remove-Item -force C:\Windows\Temp\diskspd.zip

$Test = .\Diskspd.exe -b128K -d10 -o8 -t"$CoreN" -w50 -L -c1M -si C:\io.dat
$ReadResults = $Test[-32] | convertfrom-csv -Delimiter "|" -Header Bytes,IO,Mib,IOPS,File,Latency | Select-Object IO,MIB,IOPs,Latency
$WriteResults = $Test[-22] | convertfrom-csv -Delimiter "|" -Header Bytes,IO,Mib,IOPS,File,Latency | Select-Object IO,MIB,IOPS,Latency
$Results = $Test[-9] | convertfrom-csv -Delimiter "|" -Header %-ile,Read,Write,Total | Select-Object Read,Write,Total

Write-Host PHYSICAL DRIVE RESULTS
Write-Host Drive Letter: $DriveSize.DeviceID
Write-Host Drive Capacity '(GB)' $Capacity
Write-Host Free space '(GB)' $FreeSpace

Write-Host Read Speeds $ReadResults
Write-Host Write Speeds $WriteResults
if ($Results.total -le 1)
{Write-Host Drive Speeds are Excellent}
else
{if ($Results.total -le 5)
{Write-Host Drive Speeds are Very Good}
else
{if ($Results.total -le 10)
{Write-Host Drive Speeds are Good}
else
{Write-Host Drive Speeds are GARBAGE}
}
}
Write-Host
Remove-Item diskspd.exe
Remove-Item -Recurse -Force diskspd 
}
Function Printers{
#Get-CimInstance -class win32_Printer
#List installed printers
Write-Host
Write-Host Installed Printers
(Get-CimInstance -class win32_Printer).Name
}

Write-Host Information as of: $((Get-Date).ToString())

SysInfo
Disk
RAM
NetStat
#Printers