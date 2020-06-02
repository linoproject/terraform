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

variable "template" {
    type = object({
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
    })
}

