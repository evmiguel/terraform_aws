#---------------------------------------------------------------
# Swagger Cognito User Pool Resources
#---------------------------------------------------------------
resource "aws_cognito_user_pool" "blog_user_pool" {
    name                = "${var.blog_user_pool_name}",
    alias_attributes    = [ "email", "preferred_username" ],
}

resource "aws_cognito_user_pool_domain" "blog_user_pool_domain" {
  domain        = "${var.blog_auth_domain}"
  user_pool_id  = "${aws_cognito_user_pool.blog_user_pool.id}"
}

resource "aws_cognito_user_pool_client" "blog_user_pool_client" {
    name            = "${var.blog_user_pool_name}-client"
    user_pool_id    = "${aws_cognito_user_pool.blog_user_pool.id}"
}


#---------------------------------------------------------------
# Swagger Cognito Identity Pool Resources
#---------------------------------------------------------------
resource "aws_cognito_identity_pool" "blog_identity_pool" {
    identity_pool_name                  = "${var.blog_identity_pool_name}"
    allow_unauthenticated_identities    = true
    cognito_identity_providers {
        client_id       = "${aws_cognito_user_pool_client.blog_user_pool_client.id}"
        provider_name   = "cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.blog_user_pool.id}"
    }
}

resource "aws_cognito_identity_pool_roles_attachment" "blog_identity_pool_attch" {
  identity_pool_id = "${aws_cognito_identity_pool.blog_identity_pool.id}"
  roles {
    "authenticated"     = "${aws_iam_role.blog_authenticated.arn}"
    "unauthenticated"   = "${aws_iam_role.blog_unauthenticated.arn}"
  }
}

resource "aws_iam_role" "blog_authenticated" {
    name = "blog-authenticated",
    assume_role_policy = "${data.template_file.blog_authenticated_policy.rendered}"
}

data "template_file" "blog_authenticated_policy" {
        template = "${file("templates/cognito_auth_role.json")}"
        vars {
            identity_pool_id = "${aws_cognito_identity_pool.blog_identity_pool.id}",
            authenticated    = "authenticated"
        }
}

resource "aws_iam_role" "blog_unauthenticated" {
    name = "blog-unauthenticated",
    assume_role_policy = "${data.template_file.blog_unauthenticated_policy.rendered}"
}

data "template_file" "blog_unauthenticated_policy" {
        template = "${file("templates/cognito_auth_role.json")}"
        vars {
            identity_pool_id = "${aws_cognito_identity_pool.blog_identity_pool.id}",
            authenticated    = "unauthenticated"
        }
}

