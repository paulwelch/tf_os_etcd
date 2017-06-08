# tf_os_etcd

A Terraform module for creating an Etcd v3 cluster on OpenStack (neutron)

The Etcd cluster will have `cluster_size` number of instances with the ssh keypair 
applied.  Assumes `security_group_ids` allow ports required by Etcd.  Tested with 
CoreOS Container-Linux.

## Input Variables

  * `os_auth_url` - OpenStack API auth url
  * `public_key_file` - Path to ssh public key file
  * `cluster_size` - Number of instances to start for cluster
  * `region` - ID of the OpenStack Region
  * `image_name` - Name of the OpenStack Image for instances
  * `flavor_name` - Name of the OpenStack Flavor for instances
  * `ssh_key_pair_name` - Name of ssh keypair to create in OpenStack
  * `security_group_ids` - ID of OpenStack security group
  * `network_id` - ID of OpenStack network
  * `env_name_prefix` - A unique prefix to keep clusters separate 
 
## Outputs

  * `etcd_endpoints` - List of IP addresses of Etcd cluster instances
 
## Example

```
module "etcd" {
  source = "github.com/paulwelch/tf_os_etcd"

  os_auth_url  = "https://example.com:5000/v3"
  public_key_file  = "~/.ssh/id_rsa.pub"
  cluster_size = "3"
  region  = "myregion"
  image_name  = "Container-Linux"
  flavor_name  = "m1.medium"
  ssh_key_pair_name  = "dev-key"
  security_group_ids  = [ "12312312-1231-1231-1231-123123123123" ]
  network_id  = "12312312-1231-1231-1231-123123123123123"
  env_name_prefix  = "dev"
}
```
  
## Authors

Created and maintained by [Paul Welch](https://github.com/paulwelch)

# License

MIT Licensed. See LICENSE for full details.
