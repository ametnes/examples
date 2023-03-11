resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits = 4096
}
resource "local_file" "file" {
  content = tls_private_key.key.private_key_pem
  filename = "tf-key-pair"
}

module "ec2_usw2" {
    providers = {
        aws = aws.usw2
    }
    source = "../modules/aws_ec2"
    instance_count = 4
    public_key = tls_private_key.key.public_key_openssh
    user_data     = templatefile("${path.module}/../promtail.sh", {
        region = "us-west-2"
        cloud = "aws"
        loki_endpoint = var.loki_endpoint
    })

}


module "ec2_use1" {
    providers = {
        aws = aws.use1
    }
    source = "../modules/aws_ec2"
    instance_count = 4
    public_key = tls_private_key.key.public_key_openssh
    user_data     = templatefile("${path.module}/../promtail.sh", {
        region = "us-east-1"
        cloud = "aws"
        loki_endpoint = var.loki_endpoint
    })

}

output "public_ip" {
  value = concat(module.ec2_use1.public_ips, module.ec2_usw2.public_ips)
}
