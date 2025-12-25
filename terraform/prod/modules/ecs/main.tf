resource "aws_ecs_cluster" "main" {
    name = "url-cluster"
}

data "aws_iam_role" "task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/task-def-1"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "app" {
    family                   = "url-app-task"
    execution_role_arn       = data.aws_iam_role.task_execution_role.arn
    task_role_arn            = aws_iam_role.ecs_task_role.arn
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
      "environment" : [{ name = "TABLE_NAME", value = var.ddb_table_name }],
      "environmentFiles" : [],
      "essential" : true,
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/ecs/task-def-1",
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
          "name" : "tm-1-3000-tcp",
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

    deployment_controller {
      type = "CODE_DEPLOY"
    }


    network_configuration {
        security_groups  = [var.ecs_security_group_id]
        subnets          = var.private_subnets_id
        assign_public_ip = true
    }

    load_balancer {
        target_group_arn = var.alb_target_grp_arn
        container_name   = "url-app"
        container_port   = var.app_port
    }
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_task_ddb" {
  name = "ecsTaskDynamoDBPolicy"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Effect = "Allow"
      Action = [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
      ]
      Resource = "arn:aws:dynamodb:eu-west-2:338235305910:table/test"
    }
  })
}