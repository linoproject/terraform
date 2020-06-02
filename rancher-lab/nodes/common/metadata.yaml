local-hostname: ${hostname}
instance-id: ${instance_id}
network:
  version: 2
  ethernets:
    ens192:
      dhcp4: false #true to use dhcp
      addresses:
        - ${ip}/${netmask}
      gateway4: ${gw} # Set gw here 
      nameservers:
        addresses:
          - ${dns} # Set DNS ip address here
