/*----------------------------------------------------------------------*/
/* General | Variable Definition                                        */
/*----------------------------------------------------------------------*/

variable "create_enable" {
  type        = bool
  description = ""
  default     = true
}

variable "vault_name" {
  description = "The name of the backup vault."
  type        = string
}

variable "force_destroy" {
  type        = bool
  description = "Enables the deletion of the vault"
  default     = false
}

variable "kms_key_arn" {
  description = "The ARN to encrypt the backups in the vault."
  type        = string
  default     = null
}

variable "backup_plan" {
  default     = {}
  description = "Backup plan"
  type        = any
}

variable "tags" {
  default     = {}
  description = "Tags to add to supported resources"
  type        = map(string)
}