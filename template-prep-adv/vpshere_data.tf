data vsphere_datacenter "this" {
  name = var.template.datacenter
}

data vsphere_compute_cluster "this" {

  name          = var.template.cluster
  datacenter_id = data.vsphere_datacenter.this.id
}

data vsphere_datastore "this" {

  name          = var.template.datastore
  datacenter_id = data.vsphere_datacenter.this.id
}

data vsphere_network "this" {

  name          = var.template.network
  datacenter_id = data.vsphere_datacenter.this.id
}


data vsphere_virtual_machine "template" {

  name          = var.template.template
  datacenter_id = data.vsphere_datacenter.this.id
}


data template_file "kickstartconfig" {

  # Main cloud-config configuration file.
  template = file("${path.module}/template/kickstart.yaml")
  vars = {
    user = "${var.template.user}"
    password = "${var.template.password}"
  }
}