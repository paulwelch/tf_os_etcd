provider "openstack" {
  # assumes OS environment variables
  auth_url = "${ var.os_auth_url }"
}

module "etcd_network" {
  source = "../network"

  os_auth_url = "${ var.os_auth_url }"
  count = "${ var.cluster_size }"
  security_group_ids = "${ var.security_group_ids }"
  network_id = "${ var.network_id }"
  env_name_prefix = "${ var.env_name_prefix }"
}

resource "openstack_compute_keypair_v2" "keypair" {
  name = "${ var.env_name_prefix}-${ var.ssh_key_pair_name }"
  public_key = "${ file(var.public_key_file) }"
}

resource "openstack_compute_instance_v2" "etcd_cluster" {
  depends_on = [ "module.etcd_network" ]
  count = "${ var.cluster_size }"
  name = "${ var.env_name_prefix }-etcd-${ count.index + 1 }"
  region = "${ var.region }"
  image_name = "${ var.image_name }"
  flavor_name = "${ var.flavor_name }"
  key_pair = "${ var.ssh_key_pair_name }"

  network {
    port = "${ element(module.etcd_network.ports, count.index+1) }"
  }

# doesn't work
#  lifecycle {
#    create_before_destroy = true
#  }

  user_data = "${ element(data.template_file.cloud-config.*.rendered, count.index) }"
}
