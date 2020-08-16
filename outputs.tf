output "default_alb_target_group" {
  value = module.ecs.default_alb_target_group
}

output "cluster_id" {
  value = module.ecs.cluster_id
}

output "instance_security_group_id" {
  value = module.ecs.instance_security_group_id
}
