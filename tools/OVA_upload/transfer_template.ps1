function UplodaOVATemplate {
    Param (
        [Parameter(Mandatory = $true)][String]$vCenterFQDN,
        [String]$OVADownloadUri = 'https://cloud-images.ubuntu.com/releases/18.04/release/ubuntu-18.04-server-cloudimg-amd64.ova',
        [String]$OVAFileName = 'ubuntu-18.04-server-cloudimg-amd64.ova',
        [String]$DestinationTemplateName = 'ubuntu1804template',
        [Parameter(Mandatory = $true)][String] $DestinationNetwork,
        [Parameter(Mandatory = $true)][String] $DestinationDatastoreName,
        [String]$DestinationClusterName,
        [String]$DiskFormat = 'thin'
    )

    if (-not (Test-Path  ("./"+$OVAFileName))){
        Invoke-WebRequest -Uri $OVADownloadUri -OutFile $OVAFileName
    }
    
    $vCenterConn = Connect-VIServer -Server $vCenterFQDN 
    if ($DestinationClusterName -eq $null) {
        $vmhost = Get-VMHost -Server $vCenterConn | Select-Object -First 1
    }
    else {
        $vmhost = Get-Cluster -Name $DestinationClusterName -Server $vCenterConn | Get-VMHost | Get-Random
    }
    
    $DestinationDatastore = get-datastore -Name $DestinationDatastoreName
    $ovfConfig = Get-OvfConfiguration $OVAFileName 
    $ovfConfig.NetworkMapping.VM_Network.Value = $DestinationNetwork
    Import-VApp -Source $OVAFileName -VMHost $vmhost -OvfConfiguration $ovfConfig -datastore $DestinationDatastore -DiskStorageFormat $DiskFormat -name $DestinationTemplateName -Server $vCenterConn

    Disconnect-VIServer -Server $vCenterConn -Force
}

