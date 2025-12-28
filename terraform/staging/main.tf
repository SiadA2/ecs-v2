module "vpc" {
  source                   = "../modules/vpc"
  vpc_cidr                 = var.vpc_cidr
  az_count                 = var.az_count
  endpoint_security_grp_id = aws_security_group.public.id
}


module "dynamo_db" {
  source             = "../modules/dynamodb"
  dynamodb_tablename = var.dynamodb_tablename
}

#------------------------security groups--------------------------

resource "aws_security_group" "public" {
  name        = "public-security-grp"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.http_port
    to_port     = var.http_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = var.https_port
    to_port     = var.https_port
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_tasks" {
  name        = "ecs-task-grp"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.public.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#------------------------dev ecs cluster-------------------------------


resource "aws_ecs_cluster" "main" {
    name = var.cluster_name
}

data "aws_iam_role" "task_execution_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole"
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = var.cloudwatch_log_group
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "app" {
    family                   = "url-app-task-staging"
    execution_role_arn       = data.aws_iam_role.task_execution_role.arn
    task_role_arn            = data.aws_iam_role.ecs_task_role.arn
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = var.fargate_cpu
    memory                   = var.fargate_memory
    container_definitions    = jsonencode([
  {
      "name": "url-app",
      "image": "${var.app_image}",
      "cpu": "${var.fargate_cpu}",
      "memory": "${var.fargate_memory}",
      "environment" : [{ name = "TABLE_NAME", value = var.dynamodb_tablename }],
      "environmentFiles" : [],
      "essential" : true,
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/ecs/task-def-staging",
          "awslogs-region" : "eu-west-2",
          "awslogs-stream-prefix" : "ecs"
        },
        "secretOptions" : []
      },
      "mountPoints" : [],
      "portMappings" : [
        {
          "appProtocol" : "http",
          "containerPort" : "${var.app_port}",
          "hostPort" : "${var.app_port}"
          "name" : "app-port",
          "protocol" : "tcp"
        }
      ],
      "systemControls" : [],
      "ulimits" : [],
      "volumesFrom" : []
    }
])
}

resource "aws_ecs_service" "main" {
    name            = "cb-service"
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.app.arn
    desired_count   = var.app_count
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = [aws_security_group.ecs_tasks.id]
        subnets          = module.vpc.public_subnets_id
        assign_public_ip = true
    }
}


#-----------ec2 instance for testing----------------

resource "aws_instance" "test_instance" {
  ami           = "ami-099400d52583dd8c4"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets_id[0]
  vpc_security_group_ids = [aws_security_group.public.id]
  associate_public_ip_address = true
  key_name = "my-key-pair"
}

