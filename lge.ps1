$rand = Get-Random -Maximum 999
$build_s = 22621
$build_i = [System.Environment]::OSVersion.Version.Build
$user_i = [System.Environment]::UserName
$orga = "GCE Bayreuth"
$user_1 = "Admin"
$user_2 = "Lehrer"
$user_3 = "Schueler"
$user_1_ac = '0xff008cff'
$user_1_ap = 'ff,d1,55,00,ff,b6,34,00,ff,99,10,00,ff,8c,00,00,e3,77,00,00,a1,46,00,00,65,19,00,00,00,63,b1,00'
$user_1_sm = '0xff0077e3'

Function Set-Color($ac, $ap, $sm) {
  
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"

#Accent Color Menu Key
$AccentColorMenuKey = @{
	Key   = 'AccentColorMenu';
	Type  = "DWORD";
	Value = $ac
}

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $AccentColorMenuKey.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $AccentColorMenuKey.Key -Value $AccentColorMenuKey.Value -PropertyType $AccentColorMenuKey.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $AccentColorMenuKey.Key -Value $AccentColorMenuKey.Value -Force
}


#Accent Palette Key
$AccentPaletteKey = @{
	Key   = 'AccentPalette';
	Type  = "BINARY";
	Value = $ap
}
$hexified = $AccentPaletteKey.Value.Split(',') | ForEach-Object { "0x$_" }

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $AccentPaletteKey.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $AccentPaletteKey.Key -PropertyType Binary -Value ([byte[]]$hexified)
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $AccentPaletteKey.Key -Value ([byte[]]$hexified) -Force
}


#Start Color Menu Key
$StartMenuKey = @{
	Key   = 'StartColorMenu';
	Type  = "DWORD";
	Value = $sm
}

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $StartMenuKey.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $StartMenuKey.Key -Value $StartMenuKey.Value -PropertyType $StartMenuKey.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $StartMenuKey.Key -Value $StartMenuKey.Value -Force
}

Stop-Process -ProcessName explorer -Force -ErrorAction SilentlyContinue

}



if ( $build_i -eq $build_s ) {
    Write-Host "Windows Build $build_s detected." -ForegroundColor "Cyan"
} else {
    Write-Host "Windows Build $build_i detected, but LGE needs to run on Windows Build $build_s." -ForegroundColor "Red"
    break
}

# cls
Write-Host "###########################" -ForegroundColor "Blue"
Write-Host "#                         #" -ForegroundColor "Blue"
Write-Host "#   _      _____ ______   #" -ForegroundColor "Blue"
Write-Host "#  | |    / ____|  ____|  #" -ForegroundColor "Blue"
Write-Host "#  | |   | |  __| |__     #" -ForegroundColor "Blue"
Write-Host "#  | |   | | |_ |  __|    #" -ForegroundColor "Blue"
Write-Host "#  | |___| |__| | |____   #" -ForegroundColor "Blue"
Write-Host "#  |______\_____|______|  #" -ForegroundColor "Blue"
Write-Host "#                         #" -ForegroundColor "Blue"
Write-Host "#   2023 - GCE-Bayreuth   #" -ForegroundColor "Blue"
Write-Host "#                         #" -ForegroundColor "Blue"
Write-Host "###########################" -ForegroundColor "Blue"
Write-Host ""

if ( $user_i -eq $user_1 ) {
    Write-Host "$user_1 Account detected." -ForegroundColor "Cyan"
    # Start-Process -Verb runas -FilePath "C:\Users\$user_1\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk" -ArgumentList "iwr -useb https://raw.githubusercontent.com/2ym/lge/main/ac-test.ps1 | iex"
    # Set-Color($user_1_ac, $user_1_ap, $user_1_sm)
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name 'AccentColorMenu' -Value '0xff008cff' -Force
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name 'StartColorMenu' -Value '0xff0077e3' -Force
    Stop-Process -ProcessName explorer -Force -ErrorAction SilentlyContinue
    Write-Host "Colors set." -ForegroundColor "Cyan"
} elseif ( $user_i -eq $user_2 ) {
    Write-Host "$user_2 Account detected." -ForegroundColor "Cyan"
    # Start-Process -Verb runas -FilePath "C:\Users\$user_2\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk" -ArgumentList "iwr -useb https://raw.githubusercontent.com/2ym/lge/main/lehrer.ps1 | iex"
} elseif ( $user_i -eq $user_3 ) {
    Write-Host "$user_3 Account detected." -ForegroundColor "Cyan"
    # Start-Process -Verb runas -FilePath "C:\Users\$user_3\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk" -ArgumentList "iwr -useb https://raw.githubusercontent.com/2ym/lge/main/lehrer.ps1 | iex"
} else {
    Write-Host "No valid Account Name detected." -ForegroundColor "Red"
    break
}

Start-Transcript $ENV:TEMP\lge$rand.log -Append
(Get-WmiObject Win32_ComputerSystem).Rename("Placeholder") | Out-Null

###############################################################################
## Removing Default Windows Applications                                     ##
###############################################################################

Write-Host "Removing Default Windows Applications..." -ForegroundColor "Cyan"

# Uninstall 3D Builder
Get-AppxPackage "Microsoft.3DBuilder" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.3DBuilder" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Adobe Creative Cloud Express
Get-AppxPackage "AdobeSystemsIncorporated.AdobeCreativeCloudExpress" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "AdobeSystemsIncorporated.AdobeCreativeCloudExpress" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Alarms and Clock
Get-AppxPackage "Microsoft.WindowsAlarms" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.WindowsAlarms" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Amazon Prime Video
Get-AppxPackage "AmazonVideo.PrimeVideo" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "AmazonVideo.PrimeVideo" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Autodesk Sketchbook
Get-AppxPackage "*.AutodeskSketchBook" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "*.AutodeskSketchBook" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Bing Finance
Get-AppxPackage "Microsoft.BingFinance" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.BingFinance" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Bing News
Get-AppxPackage "Microsoft.BingNews" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.BingNews" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Bing Sports
Get-AppxPackage "Microsoft.BingSports" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.BingSports" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Bing Weather
Get-AppxPackage "Microsoft.BingWeather" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.BingWeather" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Bubble Witch 3 Saga
Get-AppxPackage "king.com.BubbleWitch3Saga" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "king.com.BubbleWitch3Saga" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Calendar and Mail
Get-AppxPackage "Microsoft.WindowsCommunicationsApps" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.WindowsCommunicationsApps" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Candy Crush Soda Saga
Get-AppxPackage "king.com.CandyCrushSodaSaga" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "king.com.CandyCrushSodaSaga" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall ClipChamp Video Editor
Get-AppxPackage "Clipchamp.Clipchamp" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Clipchamp.Clipchamp" | Remove-AppxProvisionedPackage -Online

# Uninstall Cortana
Get-AppxPackage "Microsoft.549981C3F5F10" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.549981C3F5F10" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Disney+
Get-AppxPackage "Disney.37853FC22B2CE" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Disney.37853FC22B2CE" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Disney Magic Kingdoms
Get-AppxPackage "*.DisneyMagicKingdoms" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "*.DisneyMagicKingdoms" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Dolby
Get-AppxPackage "DolbyLaboratories.DolbyAccess" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "DolbyLaboratories.DolbyAccess" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Facebook
Get-AppxPackage "Facebook.Facebook*" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Facebook.Facebook*" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Get Office, and it's "Get Office365" notifications
Get-AppxPackage "Microsoft.MicrosoftOfficeHub" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.MicrosoftOfficeHub" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Instagram
Get-AppxPackage "Facebook.Instagram*" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Facebook.Instagram*" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Maps
Get-AppxPackage "Microsoft.WindowsMaps" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.WindowsMaps" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall March of Empires
Get-AppxPackage "*.MarchofEmpires" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "*.MarchofEmpires" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Messaging
Get-AppxPackage "Microsoft.Messaging" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.Messaging" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Mobile Plans
Get-AppxPackage "Microsoft.OneConnect" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.OneConnect" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall OneNote
Get-AppxPackage "Microsoft.Office.OneNote" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.Office.OneNote" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Paint
Get-AppxPackage "Microsoft.Paint" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.Paint" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall People
Get-AppxPackage "Microsoft.People" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.People" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Photos
# Get-AppxPackage "Microsoft.Windows.Photos" -AllUsers | Remove-AppxPackage -AllUsers
# Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.Windows.Photos" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Print3D
Get-AppxPackage "Microsoft.Print3D" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.Print3D" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Skype
Get-AppxPackage "Microsoft.SkypeApp" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.SkypeApp" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall SlingTV
Get-AppxPackage "*.SlingTV" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "*.SlingTV" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Solitaire
Get-AppxPackage "Microsoft.MicrosoftSolitaireCollection" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Spotify
Get-AppxPackage "SpotifyAB.SpotifyMusic" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "SpotifyAB.SpotifyMusic" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall StickyNotes
Get-AppxPackage "Microsoft.MicrosoftStickyNotes" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.MicrosoftStickyNotes" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Sway
Get-AppxPackage "Microsoft.Office.Sway" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.Office.Sway" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall TikTok
Get-AppxPackage "*.TikTok" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "*.TikTok" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Microsoft ToDos
Get-AppxPackage "Microsoft.ToDos" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.ToDos" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Twitter
Get-AppxPackage "*.Twitter" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "*.Twitter" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Voice Recorder
Get-AppxPackage "Microsoft.WindowsSoundRecorder" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.WindowsSoundRecorder" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall XBox
Get-AppxPackage "Microsoft.XboxGamingOverlay" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppxPackage "Microsoft.GamingApp" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.XboxGamingOverlay" | Remove-AppxProvisionedPackage -Online -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.GamingApp" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Your Phone
Get-AppxPackage "Microsoft.YourPhone" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.YourPhone" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Zune Music (Groove)
Get-AppxPackage "Microsoft.ZuneMusic" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.ZuneMusic" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Zune Video
Get-AppxPackage "Microsoft.ZuneVideo" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.ZuneVideo" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Windows Media Player
Disable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -NoRestart -WarningAction SilentlyContinue | Out-Null

# Uninstall Microsoft Teams (Personal Edition)
Get-AppxPackage "MicrosoftTeams" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "MicrosoftTeams" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Feedback Hub
Get-AppxPackage "Microsoft.WindowsFeedbackHub" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.WindowsFeedbackHub" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Get Started / Tips
Get-AppxPackage "Microsoft.Getstarted" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.Getstarted" | Remove-AppxProvisionedPackage -Online -AllUsers

# Uninstall Quick Assist (Remotehilfe)
Get-AppxPackage "MicrosoftCorporationII.QuickAssist" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "MicrosoftCorporationII.QuickAssist" | Remove-AppxProvisionedPackage -Online -AllUsers



###############################################################################
## Setting Custom Registry Keys                                              ##
###############################################################################

Write-Host "Setting Custom Registry Keys..." -ForegroundColor "Cyan"

# Registry Key Dark Mode System
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" 0

# Registry Key Dark Mode Apps
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" 0

# Registry Key Disable Bing Search
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "BingSearchEnabled" 0

# Registry Key Task Bar Hide Search
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "SearchboxTaskbarMode" 0

# Registry Key Task Bar Hide Chat
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarMn" 0

# Registry Key Task Bar Hide Task View
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowTaskViewButton" 0

# Registry Key Task Bar Hide Widgets
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarDa" 0

# Registry Key Task Bar Left
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAl" 0

# Registry Key Explorer Show File Extensions
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

# Registry Key Control Panel Icon Size
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel" "AllItemsIconView" 0

# Registry Control Panel View
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel" "StartupPage" 1
