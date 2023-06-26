#!/usr/bin/pwsh


############

# EDIT: CURRENT HOST/IP TO UPDATE OTHER HOSTS
$current_host = 'f2.mangekyo.xyz'

# IP/HOST: UPDATE OTHER MASTERNODES (current machine must be the last)
$hosts = @(
	'f1.mangekyo.xyz'
	'f3.mangekyo.xyz'
	'f4.mangekyo.xyz'
	'f5.mangekyo.xyz'
	'f6.mangekyo.xyz'
	'f2.mangekyo.xyz'
)

############

$res = Invoke-RestMethod -Uri https://api.github.com/repos/firoorg/firo/releases/latest
if (-not $res) { exit }

foreach ($i in $res.assets) {
	if ($i.name -match 'linux64') {
		$x = $i
		Break
	}
}

$version = Get-Content -Path /root/version.txt
$check_version = $res.name
$filename = $x.name
$download_url = $x.browser_download_url


# $download_url or http://$current_host/$filename
$update_cmd = @"
	wget -cnd --tries=99 --retry-connrefused --timeout=30 --no-check-certificate https://$current_host/$filename -O /root/$filename
	/root/firo/bin/firo-cli stop
	rm -rf /root/firo
	tar xzvf /root/$filename
	a=`$(tar -tf /root/$filename | head -1) ; mv `$a /root/firo
	rm /root/$filename
	reboot
"@

# new version detected
if ($version -notmatch $check_version) {
	Write-Host "New version detected $check_version"
	Set-Content -Path /root/version.txt -Value $check_version -NoNewline
	wget -cnd --tries=99 --retry-connrefused --timeout=30 $download_url -O /root/$filename
	Copy-Item -Path $filename -Destination /www/
	
	# UPDATE OTHER MASTERNODES (current machine must be the last)
	foreach ($h in $hosts) {
		ssh root@$h $update_cmd
	}
	
	
	# UPDATE LOCAL
#	~/firo/bin/firo-cli stop
#	Remove-Item -Path firo -Recurse -Force
#	tar xzvf $filename
#	tar -tf $filename | select -First 1 | Rename-Item -NewName firo
#	reboot
} else {
	Write-Host "No new version"
	Write-Host "Current version: $check_version"
}

exit 0













