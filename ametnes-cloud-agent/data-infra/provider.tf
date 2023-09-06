terraform {
  required_providers {
    ametnes = {
      source = "ametnes/ametnes"
      version = "0.3.3"
    }
  }
}

# Init and create the provider
provider "ametnes" {
  host = "https://cloud.ametnes.com/api/c/v1"
  token = var.token
  username = var.username

}
