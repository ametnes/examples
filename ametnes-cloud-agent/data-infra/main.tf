# Create a lcoation.
data "ametnes_location" "location" {
  name = var.location_name
  code = var.location_code
}

# Create project that will host all your resources.
data "ametnes_project" "project" {
  name = var.project
}

# Create a service resource.
resource "ametnes_service" "mysql" {
  name = "MySql-Demo-Instance"
  project = data.ametnes_project.project.id
  location = data.ametnes_location.location.id
  kind = "mysql:8.0"
  description = "Mysql Demo Instance"
  capacity {
    storage = 10
    memory = 1
    cpu = 1
  }
  nodes = 1
  config = {
    "admin.user" = "admin"
    "admin.password" = "adminusa"
    "public.visible" = "true"
  }
}

output "mysql_connections" {
  value = ametnes_service.mysql.connections
}