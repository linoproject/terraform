# Template preparation for Rancher

In order to prepare the template just:
1. Write terraform.tfvars file
2. Run template preparation and wait for VM configuration competition 
3. Poweroff VM and convert as a template (or clone as Template) naming the template: ubuntu1804templateCloudInitAdv

Here an example of terraform.tfvars file:
```ruby
vsphere_env = {
    user     = "administrator@vsphere.local"
    password = "SuperPassword1!"
    server   = "vcenter.yourdomain.lab"
}

template = {
    
    vCPU = 1
    vMEM = 1024
    vmname = "tpl01-adv"
    
    datastore = "datastore1"
    datacenter = "HomeLabWorkload"
    network = "lablan"
    cluster = "workload"
    template = "ubuntu1804template"
    

    hostname = "tpl01-adv"
    domain_name = "yourdomain.lab"
    user = "local"
     password = "SuperPassword1!"
}
```

TODO: I'll push a PowerCLI sequence for automatic template creation.