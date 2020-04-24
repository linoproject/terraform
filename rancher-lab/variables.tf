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
        vmname = string
        datastore = string
        network = string
        user = string
        password = string
        template = string
        cluster = string
        datacenter = string
        hostname = string
        ip = string
        netmask = string
    }))
}

