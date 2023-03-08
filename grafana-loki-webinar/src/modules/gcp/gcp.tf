data "google_compute_zones" "available" {
}
resource "google_compute_instance" "vm_instance" {
    name         = "gcptutorials-vm"
    machine_type = "f1-micro"
    zone = data.google_compute_zones.available.names[0]
  
    boot_disk {
      initialize_params {
        image = "ubuntu-os-cloud/ubuntu-2004-lts"
      }
    }    
    network_interface {       
      network = "default"
      access_config {
      }
    }

    metadata_startup_script = var.user_data
  }