variable "account_key_file_location" {}
variable "username" {}
variable "project_name" {}
variable "disk_image" {}
variable "number_of_cpus" {}
variable "ram_size_mb" {}
variable "hard_drive_size_gp" {}
variable "private_ssh_key_location" {}
variable "public_ssh_key_location" {}
variable "gpu_type" {}
variable "number_of_gpus" {}
variable "script_to_run_on_machine_creation" {}
variable "script_to_run_on_machine_startup" {}
variable "start_jupyter_server" {}

provider "google" {
  credentials = "${var.account_key_file_location}"
  project     = "${var.project_name}"
  region      = "us-east1"
}

resource "google_compute_instance" "vm" {
  count        = 1
  name         = "${element(split("_", var.username), 0)}-${var.project_name}"
  machine_type = "custom-${var.number_of_cpus}-${var.ram_size_mb}"
  zone         = "us-east1-c"
  allow_stopping_for_update = true
  tags = ["${var.project_name}", "${element(split("_", var.username), 0)}"]

 boot_disk {
    initialize_params {
      image = "${var.disk_image}"
      size = "${var.hard_drive_size_gp}"
      type = "pd-ssd"
    }
  }

  metadata = {
    install-nvidia-driver = "True"
    ssh-keys = "${var.username}:${file(var.public_ssh_key_location)}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP - leaving this block empty will generate a new external IP and assign it to the machine
    }
  }

  guest_accelerator{
    type = "${var.gpu_type}"
//    type = "nvidia-tesla-p100"
//    type = "nvidia-tesla-k80"
    count = "${var.number_of_gpus}"
  }

  scheduling{
    on_host_maintenance = "TERMINATE" // Need to terminate GPU on maintenance
  }

  metadata_startup_script = "${file(var.script_to_run_on_machine_startup)}"

  provisioner "remote-exec" {
    script = "${var.script_to_run_on_machine_creation}"
    connection {
      user = "${var.username}"
      type = "ssh"
      private_key = "${file(var.private_ssh_key_location)}"
    }
  }

}

resource "google_compute_firewall" "firewall" {
  name    = "${element(split("_", var.username), 0)}-${var.project_name}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8008"]
  }

  source_tags = ["jupyter8008", "${var.project_name}", "${element(split("_", var.username), 0)}"]
}

output "ip" {
  value = "${google_compute_instance.vm.network_interface.0.access_config.0.nat_ip}"
}