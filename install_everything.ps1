Install-Module -Name PSWindowsUpdate -Force
Import-Module PSWindowsUpdate

#Check for installed software
#function check_for_install ($software_list) {
#  $software = Get-CimInstance -ClassName Win32_OperatingSystem |  Where-Object { $_.Name -like 'winget' }

#}

function show_menu {
   param(
      [string]$Title = "Install Everything"      
   )
   Clear-Host
   Write-Host "======================= Title ======================="
   Write-Host "1 -option Start the Script press '1' "
}
function download_winget {
   $winget_link = @(      
      'https://github.com/microsoft/winget-cli/releases/download/v1.3.1741/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'      
   )      
   $winget_link | ForEach-Object { Start-BitsTransfer $_ -Destination "C:\Windows\Temp" }
}
function install_winget {   
   Start-Process "C:\Windows\Temps\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe"   
}
function office365_uninstallxml_download {   
   $xml_files = @(          
      "https://raw.githubusercontent.com/Jhman33/ps1scripts/main/uninstall.xml")
   
   $xml_files | ForEach-Object { Start-BitsTransfer $_ -Destination "C:\Program Files\OfficeDeploymentTool" }   
} 

#Get & install windows update
function update_windows {
   Get-WindowsUpdate
   Install-WindowsUpdate -AcceptAll
}
function update_windows_store {
   Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod
} 

function install-programs {
   $winget_install_list = @(
      "Google.Chrome",
      "Adobe.Acrobat.Reader.64-bit",
      "Foxit.FoxitReader",
      "VideoLAN.VLC",
      "Microsoft.OfficeDeploymentTool"
   )

   foreach ($software in $winget_install_list) {
      winget install $software
   }
}
function install_office {
   office365_uninstallxml_download  
   $xml = @(
      "uninstall.xml"
      "configuration-Office365-x64.xml"
   )     
   $xml | ForEach-Object { start-Process -FilePath "setup.exe" -Wait -WorkingDirectory "C:\Program Files\OfficeDeploymentTool\" -ArgumentList "/configure $_" }
}

do {
   show_menu
   $selection = Read-Host "Please make a slection"
   switch ($selection) {
      '1' {
         update_windows_store
         update_windows            
         install_winget
         install-programs
         install_office
      } 
   }
   Pause
} until ($selection -eq 'q')