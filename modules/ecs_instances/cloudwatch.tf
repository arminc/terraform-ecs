# Because alarms cost money we want to share them per log group. Therefore we want all environments in one log group. 
# For example: we have a CloudWatch LogGroup named 'docker' where you can find streams 'ENV/IP', like 'test/10.0.0.1'.  
# Consequence: When you have multiple ECS environments in one account you can only create the LogGroups once.
# This means that the other enviourments have to import the log groups.
# If you don't want that just create new log groups per enviourment.
resource "aws_cloudwatch_log_group" "dmesg" {
  name              = "/var/log/dmesg"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "docker" {
  name              = "/var/log/docker"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "ecs-agent" {
  name              = "/var/log/ecs/ecs-agent.log"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "ecs-init" {
  name              = "/var/log/ecs/ecs-init.log"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "audit" {
  name              = "/var/log/ecs/audit.log"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "messages" {
  name              = "/var/log/messages"
  retention_in_days = 30
}
