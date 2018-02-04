output "blog_user_pool_id" {value = "${aws_cognito_user_pool.blog_user_pool.id}"}
output "blog_user_pool_client_id" { value = "${aws_cognito_user_pool_client.blog_user_pool_client.id}" }
