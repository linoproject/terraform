provider "vsphere" {
  user           = var.vsphere_env.user
  password       = var.vsphere_env.password
  vsphere_server = var.vsphere_env.server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}


resource vsphere_virtual_machine "template" {

  resource_pool_id = data.vsphere_compute_cluster.this.resource_pool_id
  datastore_id     = data.vsphere_datastore.this.id

  name = var.template.vmname
  num_cpus = var.template.vCPU
  memory   = var.template.vMEM
  
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  cdrom {
    client_device = true
  }

  network_interface {
    network_id   = data.vsphere_network.this.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  wait_for_guest_net_timeout = 0

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  vapp {
    properties ={
      hostname = var.template.hostname
      user-data = base64encode(data.template_file.kickstartconfig.rendered)
    }
  }
  
}

