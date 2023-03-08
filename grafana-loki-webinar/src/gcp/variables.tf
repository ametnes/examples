variable "region" {
    type = string
    default = "us-central"
}
variable "project" {
    type = string
}
# variable "user" {
#     type = string
# }
variable "credentials" {
    type = string
}

variable "loki_endpoint" {
  type = string
}