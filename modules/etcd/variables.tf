variable "os_auth_url" {
  type = "string"

  description = <<EOF
OpenStack authentication URL for the API. NOTE: Some OS environments require /v3 in the URL to correctly identify API version.
EOF
}

variable "public_key_file" {
  type = "string"

  description = <<EOF
Path to public key file to use on VM instances for ssh access.
EOF
}

variable "cluster_size" {
  type = "string"

  description = <<EOF
Number of ETCD instances for cluster.  Should be an odd number for quorum.
EOF
}

variable "region" {
  type = "string"

  description = <<EOF
OS Region ID.
EOF
}

variable "image_name" {
  type = "string"

  description = <<EOF
OS Image Name for VM instances.
EOF
}

variable "flavor_name" {
  type = "string"

  description = <<EOF
OS Flavor Name for VM instances.
EOF
}

variable "ssh_key_pair_name" {
  type = "string"

  description = <<EOF
Name of keypair to create in OS.
EOF
}

variable "security_group_ids" {
  type = "list"

  description = <<EOF
OS Security Groups ID's.
EOF
}

variable "network_id" {
  type = "string"

  description = <<EOF
OS Network ID.
EOF
}

variable "env_name_prefix" {
  type = "string"

  description = <<EOF
Prefix for environment to use on OS names.  This allows you to create
more than one cluster with unique naming.
EOF
}
