output "default_alb_target_group" {
  value = module.alb.default_alb_target_group
}

output "cluster_id" {
  value = aws_ecs_cluster.cluster.id
}
