provider "aws" {
  region = "us-west-2"
}

resource "aws_ecs_cluster" "hello-world" {
  name = "hello-world-cluster"
}

resource "aws_ecs_task_definition" "web" {
  family                   = "hello-world"
  container_definitions    = <<DEFINITION
[
  {
    "name": "web",
    "image": "httpd:latest",
    "essential": true,
    "memory": 256,  
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
  
  network_mode = "awsvpc"
  
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
  
  cpu = "256"
  
  memory = "512"
  
  task_role_arn = "arn:aws:iam::123456789012:role/ecsTaskRole"
  
  volume {
    name = "test-volume"
  }
}

resource "aws_ecs_service" "web" {
  name            = "hello-world-service"
  cluster         = aws_ecs_cluster.hello-world.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 1

  network_configuration {
    awsvpc_configuration {
      subnets          = ["subnet-011dad032feb4a3ad"]
      security_groups  = ["sg-0b252545ff9dbbfc2"]
    }
  }
}
