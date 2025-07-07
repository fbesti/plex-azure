resource "google_compute_instance" "example" {
  name         = "oidc-vm"
  machine_type = var.gcp_machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = var.gcp_boot_image
    }
  }

  network_interface {
    network       = "default"
    access_config {}
  }

  tags = ["terraform"]
}