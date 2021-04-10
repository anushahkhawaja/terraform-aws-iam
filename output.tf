output "webserver_role_name" {

    value = aws_iam_role.ec2_s3_admin_role.name
    description = "Name of the role assigned to webserver"
  
}