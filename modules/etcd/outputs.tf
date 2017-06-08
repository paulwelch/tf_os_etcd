output "etcd_endpoints" {
  value = [ "${ module.etcd_network.all_fixed_ips }" ]
}
