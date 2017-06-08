data "template_file" "host_url_wrapper" {

  template = "$${list_of_urls}"

  vars {
    list_of_urls = "${ join(",", data.template_file.host_url.*.rendered ) }"
  }
}

data "template_file" "host_url" {
  depends_on = [ "module.etcd_network" ]
  count = "${ var.cluster_size }"

  template = "$${env_name_prefix}-etcd-${count.index+1}=http://$${host_addr}:2380"

  vars {
    env_name_prefix = "${ var.env_name_prefix }"
    host_addr = "${ element(module.etcd_network.all_fixed_ips, count.index+1) }"
  }
}
