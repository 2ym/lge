$winbuild_s = 22621
$winbuild_i = [System.Environment]::OSVersion.Version.Build
$username_i = [System.Environment]::UserName
$organization = "GCE Bayreuth"
$username_1 = "Admin"
$username_2 = "Lehrer"
$username_3 = "Schueler"

if ( $winbuild_i -eq $winbuild_s ) {
    Write-Host "Windows Build $winbuild_s detected." -ForegroundColor "Cyan"
} else {
    Write-Host "Windows Build $winbuild_i detected, but LGE needs to run on Windows Build $winbuild_s." -ForegroundColor "Red"
    break
}

if ( $username_i -eq $username_1 ) {
    Write-Host "$username_1 Account detected." -ForegroundColor "Cyan"
    Start-Process -Verb runas -FilePath "C:\Users\$username_1\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk" -ArgumentList "iwr -useb https://raw.githubusercontent.com/2ym/lge/main/admin.ps1 | iex"
} elseif ( $username_i -eq $username_2 ) {
    Write-Host "$username_2 Account detected." -ForegroundColor "Cyan"
    Start-Process -Verb runas -FilePath "C:\Users\$username_2\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk" -ArgumentList "iwr -useb https://raw.githubusercontent.com/2ym/lge/main/lehrer.ps1 | iex"
} elseif ( $username_i -eq $username_3 ) {
    Write-Host "$username_3 Account detected." -ForegroundColor "Cyan"
    Start-Process -Verb runas -FilePath "C:\Users\$username_3\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk" -ArgumentList "iwr -useb https://raw.githubusercontent.com/2ym/lge/main/lehrer.ps1 | iex"
} else {
    Write-Host "No valid Account Name detected." -ForegroundColor "Red"
    break
}
