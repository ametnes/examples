provider "google" {
  project = var.project
  region  = var.region
  credentials = var.credentials
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
    # project = var.project
    zone = "${var.region}-a"
    user_data = templatefile("${path.module}/../promtail.sh", {
        region = var.region
        cloud = "gcp"
        loki_endpoint = var.loki_endpoint
    })
}
