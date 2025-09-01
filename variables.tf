/*----------------------------------------------------------------------*/
/* Common |                                                             */
/*----------------------------------------------------------------------*/

variable "metadata" {
  type = any
}
/*----------------------------------------------------------------------*/
/* AWS Backup | Variable Definition                                     */
/*----------------------------------------------------------------------*/
variable "aws_backup_parameters" {
  type        = any
  description = "AWS Backup parameteres"
  default     = {}
}

variable "aws_backup_defaults" {
  type        = any
  description = "AWS Backup default parameteres"
  default     = {}
}