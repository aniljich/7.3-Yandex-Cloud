resource "local_file" "inventory" {
  content = <<-EOF
  [bastion]
  ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}

  [webservers]
  ${yandex_compute_instance.web-a.network_interface.0.ip_address}
  ${yandex_compute_instance.web-b.network_interface.0.ip_address}
  
  [databases]
  ${yandex_compute_instance.database.network_interface.0.ip_address}
  EOF

  filename = "../Ansible/hosts.ini"
}

resource "local_file" "ssh_config" {
  content = <<-EOF
  Host bastion
    HostName ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}
  
  Host ${yandex_compute_instance.web-a.network_interface.0.ip_address} 
    HostName ${yandex_compute_instance.web-a.network_interface.0.ip_address}
    ProxyJump bastion

  Host ${yandex_compute_instance.web-b.network_interface.0.ip_address} 
    HostName ${yandex_compute_instance.web-b.network_interface.0.ip_address}
    ProxyJump bastion
  
  Host ${yandex_compute_instance.database.network_interface.0.ip_address} 
    HostName ${yandex_compute_instance.database.network_interface.0.ip_address}
    ProxyJump bastion
  EOF

  filename = "../Ansible/ssh_config"
}