provider "aws" {
  region = "us-west-2"
}

resource "aws_ecs_task_definition" "web" {
  family                   = "hello-world"
  container_definitions    = <<DEFINITION
[
  {
    "name": "web",
    "image": "httpd:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "web" {
  name            = "hello-world-service"
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 1

  network_configuration {
    subnets          = ["subnet-011dad032feb4a3ad"]
    security_groups  = ["sg-0b252545ff9dbbfc2"]
  }
}
