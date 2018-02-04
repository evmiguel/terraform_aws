#-----------------------------------------------------------------
# Common Variables
#-----------------------------------------------------------------
variable "aws_region" {}

#-----------------------------------------------------------------
# Swagger UI - Cognito Vars
#-----------------------------------------------------------------
variable "blog_user_pool_name" { default = "blog-users" }
variable "blog_identity_pool_name" { default = "BlogIdentityPool" }
variable "blog_auth_domain" {}
