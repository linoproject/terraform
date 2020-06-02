#cloud variables

variable "vsphere_env" {
    type = object({
        server = string
        user = string
        password = string
    })
    default = {
        server = "vcsa.local.lab"
        user = "administrator@vsphere.local"
        password = "SuperPassw0rd!"
    }
}

variable "domain_env" {
    type = object({
        dns_server = string
        user = string
        password = string
        domain_name = string
    })
    default = {
        dns_server = "dns1"
        user = "administrator"
        password = "SuperPassw0rd!"
        domain_name = "mydomain.tld"
    }
}


variable "vm_env" {
    type = object({
        gw = string
        dns = string
    })
    default = {
        gw = "192.168.200.254"
        dns = "192.168.200.10"
    }
}

variable "k8s_master_env" {
    type = object({
        adminuser = string
        adminpwd = string
    })
    default = {
        adminuser = "admin"
        adminpwd = "admin"
    }
}

variable "vms" {
    type = map(object({
        vCPU = number
        vMEM = number
        vmname = string
        datastore = string
        network = string
        user = string
        password = string
        template = string
        cluster = string
        datacenter = string
        hostname = string
        domain_name = string
        ip = string
        netmask = string
    }))
}

