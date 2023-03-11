data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

data "aws_security_group" "default" {
  name = "default"
}

resource "aws_security_group_rule" "ssh" {
  description       = "Allo SSH"
  type              = "ingress"
  security_group_id = data.aws_security_group.default.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks   = ["0.0.0.0/0"]
}

module "ec2_instance" {
  count   = var.instance_count
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "ametnes-agent-tests"

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.nano"
  key_name = aws_key_pair.pair.key_name
  monitoring    = false
  vpc_security_group_ids = [
    data.aws_security_group.default.id
  ]
  associate_public_ip_address = true
  user_data = var.user_data

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = 10
    },
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

output "public_ips" {
  value = ["${module.ec2_instance.*.public_ip}"]
}