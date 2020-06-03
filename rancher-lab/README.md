# Deploy Rancher with Cloud-init and Terraform

The full example is here: link

In order to test this code you must have:
1. Windows Server 2008-2012 with Active Directory and DNS (or a Windows DNS)
2. A prepared template with the basic components for Rancher [link](./../template-prep-adv)
3. terraform.tvars as the follwing example:
   
```ruby
vsphere_env = {
    user     = "administrator@vsphere.local"
    password = "SuperPassword1!"
    server   = "vcenter.yourdomain.lab"
}

domain_env = {
    user     = ".\\Administrator"
    password = "SuperPassword1!"
    dns_server   = "<dns_server_ip>"
    domain_name = "yourdomain.lab"
}

vms = {
    rancher = {
        vCPU = 2
        vMEM = 4096
        vmname = "rancher"
        
        datastore = "datastore1"
        datacenter = "HomeLabWorkload"
        network = "lablan"
        cluster = "workload"
        template = "ubuntu1804templateCloudInitAdv" // Here the name of template built template-pre-adv
        ip = "<rancher_ip>"
        netmask = "24" 

        hostname = "rancher01"
        domain_name = "yourdomain.lab"
        user = "local"
        password = "SuperPassword1!"
    }
   
}
```
