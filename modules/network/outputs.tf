output "all_fixed_ips" {
  value = [ "${ openstack_networking_port_v2.etcd_ips.*.all_fixed_ips.0 }" ]
}

output "ports" {
  value = [ "${ openstack_networking_port_v2.etcd_ips.*.id }" ]
}
