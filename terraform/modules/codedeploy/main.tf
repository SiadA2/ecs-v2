data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_codedeploy_app" "ecs" {
  count            = var.environment == "prod" ? 1 : 0
  compute_platform = "ECS"
  name             = "example"
}

resource "aws_codedeploy_deployment_group" "ecs" {
  count                  = var.environment == "prod" ? 1 : 0
  app_name               = aws_codedeploy_app.ecs[0].name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "example"
  service_role_arn       = "arn:aws:iam::338235305910:role/ecs-codedeploy"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.cluster_name
    service_name = var.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = var.alb_listener_arn
      }

      target_group {
        name = var.target_grb_blue_name
      }

      target_group {
        name = var.target_grb_green_name
      }
    }
  }
}