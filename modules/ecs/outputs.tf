output "default_alb_target_group" {
  value = module.alb.default_alb_target_group
}

output "cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

output "instance_security_group_id" {
  value = module.ecs_instances.ecs_instance_security_group_id
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "vpc_id" {
  value = module.network.vpc_id
}
