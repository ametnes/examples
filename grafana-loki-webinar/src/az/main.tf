resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits = 4096
}
resource "local_file" "file" {
  content = tls_private_key.key.private_key_pem
  filename = "tf-key-pair"
}

module "vms" {
    source = "../modules/az_vm"
    instance_count = 4
    public_key = tls_private_key.key.public_key_openssh
    user_data     = templatefile("${path.module}/../promtail.sh", {
        region = var.resource_group_location
        cloud = "azure"
        loki_endpoint = var.loki_endpoint
    })

}

