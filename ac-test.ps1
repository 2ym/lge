$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"


#Accent Color Menu Key
$AccentColorMenuKey = @{
	Key   = 'AccentColorMenu';
	Type  = "DWORD";
	Value = '0xff008cff'
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
	Value = 'ff,d1,55,00,ff,b6,34,00,ff,99,10,00,ff,8c,00,00,e3,77,00,00,a1,46,00,00,65,19,00,00,00,63,b1,00'
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
	Value = '0xff0077e3'
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
