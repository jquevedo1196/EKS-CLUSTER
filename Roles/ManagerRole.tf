provider "aws" {
  region = var.region
  profile = var.profile
}

#--------------------------Inicio de Rol y usuario manager--------------------------
resource "aws_iam_group" "group" {
  name = var.group_name
}
resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  description = "Política de administración para el cluster de EKS"
  policy      = file(var.policy_file)
}
resource "aws_iam_group_policy_attachment" "group-attach" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.policy.arn
}
resource "aws_iam_user" "user" {
  name = var.user_name

  tags = {
    TERRAFORM = "true"
  }
}
resource "aws_iam_user_group_membership" "membership" {
  user = aws_iam_user.user.name

  groups = [
    aws_iam_group.group.name
  ]
}
resource "aws_iam_access_key" "access_key" {
  user    = aws_iam_user.user.name
}
output "access_key" {
  value = aws_iam_access_key.access_key.id
}
output "secret_key" {
  value = nonsensitive(aws_iam_access_key.access_key.secret)
}