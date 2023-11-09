# locals {
#   taskdef = templatefile("app.json.tpl", {
#     app_image      = var.app_image
#     app_port       = var.app_port
#     fargate_cpu    = var.fargate_cpu
#     fargate_memory = var.fargate_memory
#     aws_region     = var.region
#     ws_address     = var.ws_address
#     tw_image       = var.tw_image
#     install_bundle = var.install_bundle
#   })
# }