# ECS Deployment

* [What is needed for an deployment](#deployment)
* [Initial deployment](#initial-deployment)
* [How to deploy a new version?](#new-version-deployment)
* [Things you should know](#must-know)
* [Expose the service to the outside world](#alb-vs-elb)

## Deployment

Deployment process on ECS consists of two steps. First one is registering a Task Definition that holds the information about what container you want to start and what the requirements are like memory and port. The second step is creating of updating a Service Definition which defines a Service which eventually uses the Task Definition to start the containers on ECS and keeps them running.

![Deployment](../img/deployment.png)

The Task Definition documentation can be found [here][1] and the Service Definition documentation can be found [here][2]

## Initial deployment

### Register a Task Definition

To deploy an application to ECS for the first time we need to register a Task Definition, you can see an example [here][td-nginx.json]:

```json
{
  "family": "nginx",
  "containerDefinitions": [
    {
      "name": "nginx",
      "image": "nginx:alpine",
      "memory": 128,
      "portMappings": [
        {
          "containerPort": 80,
          "protocol": "tcp"
        }
      ]
    }
  ]
}
```

We are defining a Nginx docker container with 128 MB of memory and we are specifying the container listens on port 80. You can look at the Task Definition as a predefinition of the Docker run command without actually executing the run. For all possible Task Definition parameters have a look at the [documentation][3].

This is the AWS cli command to create the Task Definition:

```bash
aws ecs register-task-definition --cli-input-json file://td-nginx.json
```

### Create a Service Definition

To actually run the container we need a Service, to create a service we need the Service Definition like [here][service-create-nginx.json]:

```json
{
    "cluster": "test",
    "serviceName": "nginx",
    "taskDefinition": "@@TASKDEFINITION_ARN@@",
    "loadBalancers": [
        {
            "targetGroupArn": "@@TARGET_GROUP_ARN@@",
            "containerName": "nginx",
            "containerPort": 80
        }
    ],
    "desiredCount": 1,
    "role": "/ecs/test_ecs_lb_role",
    "deploymentConfiguration": {
        "maximumPercent": 100,
        "minimumHealthyPercent": 0
    }
}
```

While the Task Definition is not aware of the environment the Service Definition definitely is. That is why we are specifying the *cluster* name and the *role*. For service to know which Task Definition to run we need to specify the *taskDefinition* arn. This can be found in AWS console under Task Definitions or you will get it when [Creating a Service Definition](#create-a-service-definition).

We also need to provide a *targetGroupArn*, which is used to [Expose the service to the outside world](#alb-vs-elb)

For all possible Service Definition parameters have a look at the [documentation][4].

This is the AWS cli command to create the Service Definition:

```bash
aws ecs create-service --cli-input-json file://service-create-nginx.json
```

## New version deployment

When we want to deploy a new version of a container we need to update the Task Definition and register a new revision. This is done exactly as described in [Create a Service Definition](#create-a-service-definition)

### Update a Service Definition

Because we already have a service we can not create a new one we need to update it. That means we are telling the service to update our Task Definition from revision X to revision Y. Therefore we just need to provide a small set of information to the service as it can be seen [here][service-update-nginx.json]:

```json
{
    "cluster": "test",
    "service": "nginx",
    "taskDefinition": "@@TASKDEFINITION_ARN@@",
    "desiredCount": 1,
    "deploymentConfiguration": {
        "maximumPercent": 100,
        "minimumHealthyPercent": 0
    }
}
```

This is the AWS cli command to update the Service Definition:

```bash
aws ecs update-service --cli-input-json file://service-update-nginx.json
```

## ALB vs ELB

The goal is not to deploy an application but to make it accessible to the outside world or the internal services. This can be done by using the ALB (Application LoadBalancer) or the ELB (Elastic LoadBalancer). The difference is that the ELB has no knowledge of ECS or containers. It just looks at the health of the EC2 node and exposes a predefined port of that node. 

ALB is 'container' aware, in the sense that the containers get registered to the ALB and that the ALB exposes containers to the outside world instead of the EC2 node. This also means that you can have multiple containers of the same type on one EC2 node.

For a full overview have a look at the [documentation][5].

This deployment example is looking at the ALB because that makes sense in a Docker platform world. It is good to know that the ALB consists of a Listener and a target group, as seen in the illustration below. The full documentation can be found [here][6].

![Deployment](../img/alb.png)

The listener is the actual port that is exposed to the outside world. For the listener to route traffic to something it uses a *context path* like */api* to target the target group. The target group allows containers or other resources to register them self so that they receive the traffic. Target group also checks the health of the containers and decides if they are healthy or not.

## Must know

### Task Definition global

The Task Definition is global on AWS. It means when you create a Task Definition with the name *test* you can not remove it. Even when you get rid of it in the UI the next time you create a Task Definition with the name *test* it will have a revision number that is +1 of the previous version.

## TODO

* Explain LB external and internal
* Show how to push logs to CloudWatch
* Explain how to automate deployment by linking to ECS deployment scripts
* Explain the deployment strategies
* Explain service discovery strategy


    [1]: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html
    [2]: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/scheduling_tasks.html
    [3]: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
    [4]: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/service_definition_paramters.html
    [5]: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-load-balancing.html
    [6]: http://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html