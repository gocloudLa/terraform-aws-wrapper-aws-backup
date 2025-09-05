locals {
  # enabled = local.condition_create_enable
  condition_create_enable = var.create_enable ? true : false

}  