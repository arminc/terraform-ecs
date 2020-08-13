output "vpc_id" {
  value = module.vpc.id
}

output "vpc_cidr" {
  value = module.vpc.cidr_block
}

output "private_subnet_ids" {
  value = module.private_subnet.ids
}

output "public_subnet_ids" {
  value = module.public_subnet.ids
}

output "depends_id" {
  value = null_resource.dummy_dependency.id
}
