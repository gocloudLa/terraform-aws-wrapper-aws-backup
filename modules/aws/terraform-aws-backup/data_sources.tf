data "aws_caller_identity" "current" {}

data "aws_kms_key" "default_key" {
  key_id = "alias/aws/backup"
}