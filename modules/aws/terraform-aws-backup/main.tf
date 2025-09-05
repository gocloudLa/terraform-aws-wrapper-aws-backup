## AWS Backup Vault creation
resource "aws_backup_vault" "vault" {

  name          = var.vault_name
  force_destroy = var.force_destroy

  #kms_key_arn = var.kms_key_arn == null ? data.aws_kms_key.default_key.arn : var.kms_key_arn

  tags = var.tags
}

## AWS Backup Role creation
resource "aws_iam_role" "aws_backup_role" {
  count = local.condition_create_enable == true ? 1 : 0

  name               = "${var.vault_name}-vault-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "attached_policy" {
  count = local.condition_create_enable == true ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.aws_backup_role[count.index].name
}

## AWS Backup Plan Creation
resource "aws_backup_plan" "backup_policy" {
  for_each = var.backup_plan

  name = each.key

  dynamic "rule" {
    for_each = each.value.rules

    content {
      rule_name                = rule.key
      target_vault_name        = aws_backup_vault.vault.id
      schedule                 = lookup(rule.value, "schedule", null)
      start_window             = lookup(rule.value, "start_window", null)
      completion_window        = lookup(rule.value, "completion_window", null)
      enable_continuous_backup = lookup(rule.value, "enable_continuous_backup", false)
      recovery_point_tags      = lookup(rule.value, "recovery_point_tags", {})

      # Lifecycle
      dynamic "lifecycle" {
        for_each = length(lookup(rule.value, "lifecycle", {})) == 0 ? [] : [lookup(rule.value, "lifecycle", {})]
        content {
          cold_storage_after = lookup(lifecycle.value, "cold_storage_after", 0)
          delete_after       = lookup(lifecycle.value, "delete_after", 7)
        }
      }

      # Copy action
      dynamic "copy_action" {
        for_each = lookup(rule.value, "copy_actions", [])
        content {
          destination_vault_arn = lookup(copy_action.value, "destination_vault_arn", null)

          # Copy Action Lifecycle
          dynamic "lifecycle" {
            for_each = length(lookup(copy_action.value, "lifecycle", {})) == 0 ? [] : [lookup(copy_action.value, "lifecycle", {})]
            content {
              cold_storage_after = lookup(lifecycle.value, "cold_storage_after", 0)
              delete_after       = lookup(lifecycle.value, "delete_after", 7)
            }
          }
        }
      }
    }
  }

  # Tags
  tags = var.tags
}

resource "aws_backup_selection" "resource_selection" {
  for_each = local.selections

  iam_role_arn = aws_iam_role.aws_backup_role[0].arn
  name         = each.key
  plan_id      = aws_backup_plan.backup_policy[each.value.backup_plan].id

  resources     = each.value.resources
  not_resources = each.value.not_resources

  dynamic "selection_tag" {
    for_each = each.value.selection_tags
    content {
      type  = lookup(selection_tag.value, "type", null)
      key   = lookup(selection_tag.value, "key", null)
      value = lookup(selection_tag.value, "value", null)
    }
  }

  condition {
    dynamic "string_equals" {
      for_each = lookup(lookup(local.selections, "conditions", {}), "string_equals", [])
      content {
        key   = lookup(string_equals.value, "key", null)
        value = lookup(string_equals.value, "value", null)
      }
    }
    dynamic "string_like" {
      for_each = lookup(lookup(local.selections, "conditions", {}), "string_like", [])
      content {
        key   = lookup(string_like.value, "key", null)
        value = lookup(string_like.value, "value", null)
      }
    }
    dynamic "string_not_equals" {
      for_each = lookup(lookup(local.selections, "conditions", {}), "string_not_equals", [])
      content {
        key   = lookup(string_not_equals.value, "key", null)
        value = lookup(string_not_equals.value, "value", null)
      }
    }
    dynamic "string_not_like" {
      for_each = lookup(lookup(local.selections, "conditions", {}), "string_not_like", [])
      content {
        key   = lookup(string_not_like.value, "key", null)
        value = lookup(string_not_like.value, "value", null)
      }
    }
  }
}



