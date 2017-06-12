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

    - name: etcd-bootstrap.service
      command: start
      content: |
        [Unit]
        Description=etcd cluster bootstrap
        Requires=docker.service

        [Service]
        Type=oneshot
        ExecStartPre=/usr/bin/docker pull quay.io/coreos/etcd:$${etcd_version}
        ExecStart=/usr/bin/docker run -d -v /usr/share/ca-certificates/:/etc/ssl/certs -v /$${env_name_prefix}-etcd-${count.index+1}.etcd:/$${env_name_prefix}-etcd-${count.index+1}.etcd -p 2380:2380 -p 2379:2379 --name etcd-bootstrap quay.io/coreos/etcd:$${etcd_version} etcd -name $${env_name_prefix}-etcd-${count.index+1} -advertise-client-urls http://$${host_addr}:2379 -listen-client-urls http://0.0.0.0:2379 -initial-advertise-peer-urls http://$${host_addr}:2380 -listen-peer-urls http://0.0.0.0:2380 -initial-cluster-token $${env_name_prefix}-etcd-cluster -initial-cluster $${initial_cluster} -initial-cluster-state new
        ExecStart=/bin/bash -c 'until [[ $(curl -q http://localhost:2379/health | jq -r '.health') = "true" ]]; do \
          sleep 1; \
        done; \
        /usr/bin/docker rm -f etcd-bootstrap; '

    - name: etcd.service
      command: start
      content: |
        [Unit]
        Description=etcd v3
        After=etcd-bootstrap.service
        Requires=docker.service

        [Service]
        Environment=ETCD_CLUSTER_STATE=new
        Restart=always
        ExecStartPre=-/usr/bin/docker stop etcd
        ExecStartPre=-/usr/bin/docker rm -f etcd
        ExecStart=/usr/bin/docker run -v /usr/share/ca-certificates/:/etc/ssl/certs -v /$${env_name_prefix}-etcd-${count.index+1}.etcd:/$${env_name_prefix}-etcd-${count.index+1}.etcd -p 2380:2380 -p 2379:2379 --name etcd quay.io/coreos/etcd:$${etcd_version} etcd -name $${env_name_prefix}-etcd-${count.index+1} -advertise-client-urls http://$${host_addr}:2379 -listen-client-urls http://0.0.0.0:2379 -initial-advertise-peer-urls http://$${host_addr}:2380 -listen-peer-urls http://0.0.0.0:2380 -initial-cluster-token $${env_name_prefix}-etcd-cluster -initial-cluster $${initial_cluster} -initial-cluster-state $ETCD_CLUSTER_STATE
        ExecStop=/usr/bin/docker rm -f etcd
      drop-ins:
        - name: 10-etcd-state.conf
          content: |
            [Service]
            Environment=ETCD_CLUSTER_STATE=existing
EOF

  vars {
    etcd_version = "${ var.etcd_version }"
    env_name_prefix = "${ var.env_name_prefix }"
    host_addr = "${ element(module.etcd_network.all_fixed_ips, count.index+1) }"
    initial_cluster = "${ data.template_file.host_url_wrapper.rendered }"
  }
}
