Install-Module -Name PSWindowsUpdate -Force
Import-Module PSWindowsUpdate

#Check for installed software
function check_for_install ($software_list) {
   $software = Get-CimInstance -ClassName Win32_OperatingSystem |  Where-Object { $_.IdentifyingNumber -like $software_list } 
}

#Get & install windows update
function update_windows {
   Get-WindowsUpdate
   Install-WindowsUpdate -AcceptAll
}
#Install Milieu n-able
#function install-n-able {
#  start-Process -Wait -FilePath './milieu-n-able'
#}
#update-windows-store
function update_windows_store {
   Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod-MethodName UpdateScanMethod
}
function office365_install {   
   $xml_files = @(
      "configuration-Office365-x86.xml",          
      "uninstall.xml"
   )
   foreach ($xml in $xml_files){
      start-Process -FilePath "setup.exe" -Wait -PassThru -ArgumentList "/configure", $xml
   }   
}
function install-programs {
   $winget_install_list = @(
      "Google.Chrome"
      "Adobe.Acrobat.Reader.64-bit"
      "Foxit.FoxitReader"
      "VideoLAN.VLC"
   )

   foreach ($software in $winget_install_list) {
      winget install $software
   }
}

update-windows-store
update_windows
office365_install
install-programs