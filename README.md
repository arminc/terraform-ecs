# AWS ECS

This repository contains the Terraform module for creating production ready ECS in AWS.

* [What is ECS?](#what-is-ecs)
* [ECS infrastructure in AWS](#ecs-infra)
* [ECS Terraform module](#terraform-mpdule)
* [How to create the infrastructure](#create-it)
* [ECS Deployment](deployment/README.md)
* [Things you should know](#must-know)

## What is ECS

ECS stands for EC2 Container Service and is the AWS platform for running Docker containers.
The full documentation about ECS can be found [here][1], the development guide can be found [here][2]. A more fun read can be found at [The Hitchhiker's Guide to AWS ECS and Docker][7]

To understand ECS it is good to state the obvious differences against the competitors like [Kubernetes][3] or [DC/OS Mesos][4]. The mayor differences are that ECS can not be run on-prem and that it lacks advanced features. These two differences can either been seen as weakness or as strengths.

### AWS specific

You can not run ECS on-prem because it is an AWS service and not installable software. This makes it easier to maintain and setup than hosting your own Kubernetes or Mesos on-prem or in the cloud. Although it is a service it's not the same as [Google hosted Kubernetes][5]. Why? Google really offers Kubernetes as a SAAS, you don't manage any infrastructure while ECS actually requires slaves and therefore infrastructure.

What is the difference between running your own Kubernetes or Mesos? That is the lack of maintenance of the master nodes. You are only responsible for allowing the EC2 nodes to connect to ECS and ECS does the rest. This makes the ECS slave nodes replaceable and allows for low maintenance by using the standard AWS ECS optimized OS and other building blocks like autoscale etc..

### Advanced features

Although it misses some advanced features ECS plays well with other AWS services to provide simple but powerful deployments. This makes the learning curve less high for DevOps teams to run their own infrastructure. You could argue that if you are trying to do complex stuff in ECS you are either making it unnecessary complex or ECS does not fit your needs.

Having said that ECS does have a possibility to be used like a Kubernetes or Mesos by using [Blox][6]. Blox is essentially a set of tools that allows more control on the cluster and advanced deployment strategies.

## ECS infra

As stated above ECS needs EC2 nodes that are beeing used as slaves to run Docker containers on. To do so you need infrastructure for this. Here is an ECS production-ready infrastructure diagram.

![ECS infra](img/ecs-infra.png)

What are we creating:

* VPC with a /16 ip address space and an internet gateway
* We are choosing a region and a number of availability zones we want to use. Two in this case
* In every availability zone we are creating a private and a public subnet with a /24 ip address space
  * Public subnet convention is 10.x.0.x and 10.x.1.x etc..
  * Private subnet convention is 10.x.50.x and 10.x.51.x etc..
* In the public subnet we place a NAT gateway and the LoadBalancer
* The private subnets are used in the autoscale group which places instances in them
* We create an ECS cluster where the instances connect to

## Terraform module

To be able to create the stated infrastructure we are using Terraform. To allow everyone to use the infrastructure code, this repository contains the code as Terraform module so it can be easy incorporated by others.

Creating one big module does not really give a benefit of modules. Therefore the ECS module itself consists of different modules. This way it is easier for others to make changes, swap modules or use pieces from this repository even if not setting up ECS.

Details regarding how a module works or why it is setup is described in the module itself if needed.

Modules need to be used to create infrastructure. For an example on how to use the modules to create a working ECS cluster see *ecs.tf* and *ecf.tfvars*.

**Note** You need to use Terraform version 0.9.5 and above

### Conventions

These are the conventions we have in every module

* Contains main.tf where all the terraform code is
* If main.tf is too big we more *.tf files with proper names
* [Optional] Contains outputs.tf with the output parameters
* [Optional] Contains variables.tf which sets required attributes
* For grouping in AWS we set the tag "Environment" everywhere where possible

### Module structure

![Terraform module structure](img/ecs-terraform-modules.png)

## Create it

To create a working ECS cluster from this respository see *ecs.tf* and *ecf.tfvars*.

Quick way to create this from the repository as is:

```bash
terraform get && terraform apply -input=false -var-file=ecs.tfvars
```

Actual way for creating everything using the default terraform flow:

```bash
terraform get
terraform plan -input=false -var-file=ecs.tfvars
terraform apply -input=false -var-file=ecs.tfvars
```

## Must know

### SSH access to the instances

You should not put your ECS instances directly on the internet. You should not allow SSH access to the instances directly but use a bastion server for that. Having SSH access to the acceptance environment is fine but you should not allow SSH access to production instances. You don't want to make any manual changes in the production environment.

This ECS module allows you to use an AWS SSH key to be able to access the instances, for quick usage purposes the ecs.tf creates a new AWS SSH key. The private key can be found in the root of this repository with the name 'ecs_fake_private'

### ECS configuration

ECS is configured using the */etc/ecs/ecs.config* file as you can see [here][8]. There are two important configurations in this file. One is the ECS cluster name so that it can connect to the cluster, this should be specified from terraform because you want this to be variable. The other one is access to Docker Hub to be able to access private repositories. To do this safely use an S3 bucket that contains the Docker Hub configuration. See the *ecs_config* variable in the *ecs_instances* module for an example.

### Logging

All the default system logs like Docker or ECS agent should go to CloudWatch as configured in here. The ECS container logs can be pushed to CloudWatch as well but it is better to push these logs to a service like [ElasticSearch][9]. CloudWatch does support search and alerts but it is nowhere as powerful as ElasticSearch or other log services.

The [ECS configuration](#ecs-configuration) as described here allows configuration of additional [Docker log drivers][10] to be configured. For example fluentd as shown in the *ecs_logging* variable in the *ecs_instances* module.

### ECS instances

Normally there is only one group of instances like configured here. But it is possible to use the *ecs_instances* module to add more groups of different type of instances or to be used for different deployment. This makes it possible to have multiple different types of instances with different scaling options.

### LoadBalancer

It is possible to use the Application LoadBalancer and the Classic LoadBalancer with this setup. The default configuration is Application LoadBalancer because that makes more sense in combination with ECS.

## TODO

* Try and see if it is possible to use AWS commands instead of SSH access to the instances
* Show how to use and add a bastion server to the infrastructure
* Show an example on how to use fluentd to push logs to ElasticSearch
* Show how to use ELB instead of the ALB
* Show how to add an database like RDS tot the infrastructure
* Create a deployment user with proper permisions
* Show how to get EC2 and container metrics to prometheus
* Show how to use CloudWatch alarms to detect failing (loop) deployments
* Show how to use AWS Parameter Store as a secure way of accessing secrets from containers
* Explain and show an example of custom boot commands
* Explain why we use the word "default" when creating a cluster
* Explain the strategy for updating ECS nodes (EC2 node draining)
* Explain service discovery strategy


    [1]: https://aws.amazon.com/ecs/
    [2]: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html
    [3]: https://kubernetes.io/
    [4]: https://docs.mesosphere.com/
    [5]: https://cloud.google.com/container-engine/
    [6]: https://blox.github.io/
    [7]: http://start.jcolemorrison.com/the-hitchhikers-guide-to-aws-ecs-and-docker/
    [8]: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-config.html
    [9]: https://www.elastic.co/cloud
    [10]: https://docs.docker.com/engine/admin/logging/overview/
