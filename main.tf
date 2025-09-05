module "aws_backup" {
  source = "./modules/aws/terraform-aws-backup"

  for_each = var.aws_backup_parameters

  create_enable = true
  vault_name    = "${local.common_name}-${each.key}"
  force_destroy = try(each.value.force_destroy, var.aws_backup_defaults.force_destroy, false)
  kms_key_arn   = try(each.value.force_destroy, var.aws_backup_defaults.force_destroy, null)
  backup_plan   = try(each.value.backup_plan, var.aws_backup_defaults.backup_plan, {})

  tags = merge(local.common_tags, try(each.value.tags, var.aws_backup_defaults.tags, null))

}