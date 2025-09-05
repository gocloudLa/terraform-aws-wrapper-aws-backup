## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_backup_plan.backup_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_selection.resource_selection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_iam_role.aws_backup_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attached_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_kms_key.default_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_plan"></a> [backup\_plan](#input\_backup\_plan) | Backup plan | `any` | `{}` | no |
| <a name="input_create_enable"></a> [create\_enable](#input\_create\_enable) | n/a | `bool` | `true` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Enables the deletion of the vault | `bool` | `false` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN to encrypt the backups in the vault. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to supported resources | `map(string)` | `{}` | no |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | The name of the backup vault. | `string` | n/a | yes |

## Outputs

No outputs.

## Example
```
vault_name = "vault-3"
create_enable = true
force_destroy = false
kms_key_arn = "example_arn"

backup_plan = {
    "complete-plan" = {
        # Multiple rules using a list of maps
        rules = {
            "rule-1" = {
                schedule                 = "cron(0 12 * * ? *)"
                target_vault_name        = null
                start_window             = 120
                completion_window        = 360
                enable_continuous_backup = true
                lifecycle = {
                  cold_storage_after = 0
                  delete_after       = 30
                },
                copy_actions = [
                  {
                    lifecycle = {
                      cold_storage_after = 0
                      delete_after       = 90
                    },
                    destination_vault_arn = "arn:aws:backup:us-west-2:123456789101:backup-vault:Default"
                  },
                  {
                    lifecycle = {
                      cold_storage_after = 0
                      delete_after       = 90
                    },
                    destination_vault_arn = "arn:aws:backup:us-east-2:123456789101:backup-vault:Default"
                  }
                ]    
                recovery_point_tags = {
                  Environment = "production"
                }
            },
            "rule-2" = {
                schedule            = "cron(0 7 * * ? *)"
                target_vault_name   = "Default"
                schedule            = null
                start_window        = 120
                completion_window   = 360
                lifecycle           = {}
                copy_action         = []
                recovery_point_tags = {}
            }
        }
        # Multiple selections
        #  - Selection-1: By resources and tag
        #  - Selection-2: Only by resources
        #  - Selection-3: By resources and conditions
        selections = {
            "selection-1" = {
                resources     = ["arn:aws:dynamodb:us-east-1:123456789101:table/mydynamodb-table1"]
                not_resources = []
                selection_tags = [{
                    type  = "STRINGEQUALS"
                    key   = "Environment"
                    value = "production"
                },
                {
                    type  = "STRINGEQUALS"
                    key   = "Owner"
                    value = "production"
                }]
            },
            "selection-2" = {
                resources = ["arn:aws:dynamodb:us-east-1:123456789101:table/mydynamodb-table2"]
            },
            "selection-3" = {
                resources     = ["arn:aws:dynamodb:us-east-1:123456789101:table/mydynamodb-table3"]
                not_resources = []
                conditions = {
                string_equals = [
                    {
                    key   = "aws:ResourceTag/Component"
                    value = "rds"
                    }
                    ,
                    {
                    key   = "aws:ResourceTag/Project"
                    value = "Project1"
                    }
                ]
                string_like = [
                    {
                    key   = "aws:ResourceTag/Application"
                    value = "app*"
                    }
                ]
                string_not_equals = [
                    {
                    key   = "aws:ResourceTag/Backup"
                    value = "false"
                    }
                ]
                string_not_like = [
                    {
                    key   = "aws:ResourceTag/Environment"
                    value = "test*"
                    }
                ]
                }
            }
        }
    }
}
tags = {
  Owner       = "devops"
  Environment = "production"
  Terraform   = true
}
```