resource "aws_iam_role" "ecs_default_task" {
  name = "${var.environment}_${var.cluster}_default_task"
  path = "/ecs/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ecs-tasks.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {
  current = true
}

data "template_file" "policy" {
  template = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
      "Action": ["ssm:DescribeParameters"],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": ["ssm:GetParameters"],
      "Effect": "Allow",
      "Resource": "arn:aws:ssm:$${aws_region}:$${account_id}:parameter/$${prefix}*"
    }
  ]
}
EOF

  vars {
    account_id = data.aws_caller_identity.current.account_id
    prefix     = var.prefix
    aws_region = data.aws_region.current.name
  }
}

resource "aws_iam_policy" "ecs_default_task" {
  name = "${var.environment}_${var.cluster}_ecs_default_task"
  path = "/"

  policy = data.template_file.policy.rendered
}

resource "aws_iam_policy_attachment" "ecs_default_task" {
  name       = "${var.environment}_${var.cluster}_ecs_default_task"
  roles      = ["${aws_iam_role.ecs_default_task.name}"]
  policy_arn = aws_iam_policy.ecs_default_task.arn
}
