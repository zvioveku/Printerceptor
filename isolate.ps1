Import-Module PSTerminalServices
$Printers = Get-WmiObject -Class Win32_Printer | where {$_.parameters -ne $Null}
$Connected  = get-tssession | where {(($_.State -eq "Active") -and ($_.WindowStationName -ne "Console"))}
if ($Connected.count -le 0) {


 New-PSDrive -Name HKLM -PSProvider Registry -Root Registry::HKEY_Local_Machine -ErrorAction SilentlyContinue
 
 foreach ($Printer in $Printers){

$path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Printers\" + $Printer.name
		
		 New-ItemProperty -Path $path -Name "attributes" -Value "35328" -PropertyType "dword" -Force

}

write-host "Isolation keys inserted"
Restart-Service spooler
	exit
	
	}