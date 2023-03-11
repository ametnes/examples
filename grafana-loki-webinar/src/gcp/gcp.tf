provider "google" {
  project = var.project
  region  = var.region
}

data "google_compute_zones" "available" {
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits = 4096
}
resource "local_file" "file" {
  content = tls_private_key.key.private_key_pem
  filename = "tf-key-pair"
}

module vm {
    source = "../modules/gcp"
    zone = data.google_compute_zones.available.names[0]
    user_data = templatefile("${path.module}/../promtail.sh", {
        region = var.region
        cloud = "gcp"
        loki_endpoint = var.loki_endpoint
    })
}
