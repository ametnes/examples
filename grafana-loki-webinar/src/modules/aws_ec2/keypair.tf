
resource "aws_key_pair" "pair" {
  key_name = "tf-key-pair-wbn"
  public_key = var.public_key
}
