data "template_file" "cloud-config" {
  depends_on = [ "module.etcd_network" ]
  count = "${ var.cluster_size }"

  template = <<EOF
#cloud-config

---
coreos:
  units:
    - name: docker.service
      command: start

    - name: etcd.service
      command: start
      content: |
        [Unit]
        Description=etcd v3
        Requires=docker.service

        [Service]
        Restart=always
        ExecStartPre=-/usr/bin/docker stop %n
        ExecStartPre=-/usr/bin/docker rm %n
        ExecStartPre=/usr/bin/docker pull quay.io/coreos/etcd
        ExecStart=/usr/bin/docker run -v /usr/share/ca-certificates/:/etc/ssl/certs -p 4001:4001 -p 2380:2380 -p 2379:2379 --name etcd quay.io/coreos/etcd etcd -name $${env_name_prefix}-etcd-"${count.index+1}" -advertise-client-urls http://$${host_addr}:2379,http://$${host_addr}:4001 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 -initial-advertise-peer-urls http://$${host_addr}:2380 -listen-peer-urls http://0.0.0.0:2380 -initial-cluster-token $${env_name_prefix}-etcd-cluster -initial-cluster $${initial_cluster} -initial-cluster-state new
        ExecStop=/usr/bin/docker rm -f etcd

EOF

  vars {
    env_name_prefix = "${ var.env_name_prefix }"
    host_addr = "${ element(module.etcd_network.all_fixed_ips, count.index+1) }"
    initial_cluster = "${ data.template_file.host_url_wrapper.rendered }"
  }
}
