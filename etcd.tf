variable "os_auth_url" { }
variable "public_key_file" { }
variable "cluster_size" { }
variable "region" { }
variable "image_name" { }
variable "flavor_name" { }
variable "ssh_key_pair_name" { }
variable "security_group_ids" { type="list" }
variable "network_id" { }
variable "etcd_version" { }
variable "env_name_prefix" { }

#####################################################################

module "etcd" {
  source = "./modules/etcd"

  public_key_file = "${ var.public_key_file }"
  os_auth_url = "${ var.os_auth_url }"
  cluster_size = "${ var.cluster_size }"
  region = "${ var.region }"
  image_name = "${ var.image_name }"
  flavor_name = "${ var.flavor_name }"
  ssh_key_pair_name = "${ var.ssh_key_pair_name }"
  security_group_ids = "${ var.security_group_ids }"
  network_id = "${ var.network_id }"
  etcd_version = "${ var.etcd_version }"
  env_name_prefix = "${ var.env_name_prefix }"
}

#####################################################################

output "etcd_endpoints" {
  value = [ "${ module.etcd.etcd_endpoints }" ]
}
