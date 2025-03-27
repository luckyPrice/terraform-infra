output "ec2-iam-role-profile-name" {
  value = aws_iam_instance_profile.ec2-iam-role-profile
}
output "ec2_iam_role_name" {
  value = aws_iam_role.ec2-iam-role.name
}