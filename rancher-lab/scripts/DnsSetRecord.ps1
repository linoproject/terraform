
$RecordName = "${hostname}"
$ZoneName = "${domain_name}"
$ip = "${ip}"

try { 
     $res = Resolve-DnsName -Name "$RecordName" -ErrorAction Stop
     $OldObj = Get-DnsServerResourceRecord -Name $RecordName -ZoneName $ZoneName -RRType A
     $NewObj = $OldObj.clone()
     $NewObj.RecordData.IPv4Address = [System.Net.IPAddress]::parse($ip)
     Set-DnsServerResourceRecord -NewInputObject $NewObj -OldInputObject $OldObj -ZoneName $ZoneName
     Write-Host "DONE Modify A record $RecordName.$ZoneName -> $ip"
     
}
Catch {
     Add-DnsServerResourceRecordA -Name $RecordName -ZoneName $ZoneName -AllowUpdateAny -IPv4Address $ip -ErrorAction Stop
     Write-Host "DONE Add A record $RecordName.$ZoneName -> $ip"
     
}
