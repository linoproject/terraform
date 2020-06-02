
provider "vsphere" {
  user           = var.vsphere_env.user
  password       = var.vsphere_env.password
  vsphere_server = var.vsphere_env.server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}


resource vsphere_virtual_machine "allvms" {
  for_each = var.vms

  resource_pool_id = data.vsphere_compute_cluster.this[each.key].resource_pool_id
  datastore_id     = data.vsphere_datastore.this[each.key].id

  name = each.value.vmname
  num_cpus = each.value.vCPU
  memory   = each.value.vMEM
  
  guest_id = data.vsphere_virtual_machine.template[each.key].guest_id
  scsi_type = data.vsphere_virtual_machine.template[each.key].scsi_type

  cdrom {
    client_device = true
  }

  network_interface {
    network_id   = data.vsphere_network.this[each.key].id
    adapter_type = data.vsphere_virtual_machine.template[each.key].network_interface_types[0]
  }
  wait_for_guest_net_timeout = 0

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template[each.key].disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template[each.key].disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template[each.key].disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template[each.key].id
  }


  extra_config = {
    "guestinfo.metadata"          = base64encode(data.template_file.metadataconfig[each.key].rendered)
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(data.template_file.userdataconfig[each.key].rendered)
    "guestinfo.userdata.encoding" = "base64"
  }

  provisioner "remote-exec" {
    inline = [
       "sudo cloud-init status --wait"
    ]
    connection {
			host = each.value.ip
			type     = "ssh"
			user     = each.value.user
			password = each.value.password
		} 
  }
  
  


}

resource "null_resource" "dnsrecord" {
  for_each = var.vms
  
  provisioner "file" {
    content      = data.template_file.dnsrecord[each.key].rendered
    destination = "/Temp/DNSRecord.ps1"

    connection {
      type     = "winrm"
      user     = var.domain_env.user
      password = var.domain_env.password
      host     = var.domain_env.dns_server
      insecure = true
      use_ntlm = true
      https = false
    }
  }


  provisioner "remote-exec" {
    inline = [
       "Powershell.exe /Temp/DNSRecord.ps1"
    ]
    connection {
      type     = "winrm"
      user     = var.domain_env.user
      password = var.domain_env.password
      host     = var.domain_env.dns_server
      insecure = true
      use_ntlm = true
      https = false
    }
  }

}
resource "null_resource" "install_terraform" {


  provisioner "remote-exec" {
    inline = [
       "sudo su -c /home/ubuntu/install.sh ubuntu"
    ]
    connection {
      host = var.vms["rancher"].ip
			type     = "ssh"
			user     = var.vms["rancher"].user
			password = var.vms["rancher"].password
    }
  }

  depends_on = [vsphere_virtual_machine.allvms["rancher"]]
}