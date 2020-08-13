module "alb" {
  source = "../alb"

  environment       = var.environment
  alb_name          = "${var.environment}-${var.cluster}"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
}

resource "aws_security_group_rule" "alb_to_ecs" {
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 61000
  protocol                 = "TCP"
  source_security_group_id = module.alb.alb_security_group_id
  security_group_id        = module.ecs_instances.ecs_instance_security_group_id
}
