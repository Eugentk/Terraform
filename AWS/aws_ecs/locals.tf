#-------------------------------------------------------------------------------
#                                 Locals
#-------------------------------------------------------------------------------

locals {
  app_id      = terraform.workspace
  app_env     = trimprefix(local.app_id, "${var.application_name}-")
  db_password = random_password.password.result
  db_host     = aws_db_instance.application-db.address

}
