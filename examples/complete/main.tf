module "wrapper_aws_backup" {
  source = "../../"

  metadata = local.metadata

  aws_backup_parameters = {
    "00" = {
      force_destroy = true
      # kms_key_arn
      # backup_plan
      backup_plan = {
        "plan1" = {
          rules = {
            "rule1" = {
              schedule                 = "cron(30 12 * * ? *)" # Run every hour
              start_window             = 60                    # Time in minutes
              completion_window        = 180                   # Time in minutes
              enable_continuous_backup = false
              recovery_point_tags = {
                "Environment" = "testing"
                "BackupType"  = "daily"
              }
              lifecycle = {
                delete_after = 2 # Retention time in days
              }
            }
          }
          selections = {
            "sel1" = {
              selection_tags = [{
                "type" = "STRINGEQUALS"
                key    = "AWSBACKUP"
                value  = "true"
              }]
            }
          }
        }
      }
    }
  }

  aws_backup_defaults = var.aws_backup_defaults
}