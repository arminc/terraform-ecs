output "ecs_deployer_access_key" {
  value = aws_iam_access_key.ecs_deployer.id
}

output "ecs_deployer_secret_key" {
  value = aws_iam_access_key.ecs_deployer.secret
}
