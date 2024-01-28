terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
required_version = ">= 0.13"
}

provider "yandex" {
cloud_id = "b1ggaca7lfvjfpiar285"
folder_id = "b1g6clu88o6dibdkarbv"
service_account_key_file = "/home/user/terraform/authorized_key.json"
zone = "ru-central1-b"
}

resource "yandex_compute_instance" "vm" {
  count = 2
  name = "vm${count.index}"
  platform_id               = "standard-v1"
boot_disk {
  initialize_params{
	image_id = "fd81mpc969gbg44vndkv"
	size = 5
  }
}

network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
}
resources {
    core_fraction = 5
    cores = 2
    memory = 2
}
  metadata = {
  user-data = file("./meta.yml")
  }
}
resource "yandex_vpc_network" "network-1"{
name="network1"
}


resource "yandex_vpc_subnet" "subnet-1"{
name           = "subnet1"
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = "${yandex_vpc_network.network-1.id}"
}

resource "yandex_lb_target_group" "test-1" {
  name      = "test-1"
  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = yandex_compute_instance.vm[0].network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = yandex_compute_instance.vm[1].network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "lb-1" {
  name = "lb-1"
  deletion_protection = "false"

  listener {
    name = "my-lb1"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.test-1.id
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
