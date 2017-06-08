variable "os_auth_url" {
  type = "string"

  description = <<EOF
OpenStack authentication URL for the API. NOTE: Some OS environments require /v3 in the URL to correctly identify API version.
EOF
}

variable "count" {
  type = "string"

  description = <<EOF
Number of IPs to provision.
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
