#------------------------------------------------------------------------------------
# Terraform Backend Config
#------------------------------------------------------------------------------------
terraform {
    backend "s3" {}
}

data "terraform_remote_state" "state" {
    backend = "s3"
    config {
        bucket     = "${var.backend_bucket}"
        region     = "${var.aws_region}"
        key        = "${var.state_key}"
    }
}


#------------------------------------------------------------------------------------
# Cognito Architecture
#------------------------------------------------------------------------------------
module "cognito" {
    aws_region              = "${var.aws_region}"
    source                  = "cognito"
    blog_auth_domain        = "${var.blog_auth_domain}"
}
