resource "aws_cloudwatch_log_metric_filter" "root_signin" {
  name           = "RootSignIn"
  pattern        = <<pattern
{ $.userIdentity.type = "Root" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != "AwsServiceEvent" }
pattern
  log_group_name = aws_cloudwatch_log_group.ct-lg.name

  metric_transformation {
    name      = "RootSignInCount"
    namespace = var.log_metric_namespace
    value     = 1
  }
}


resource "aws_cloudwatch_metric_alarm" "root_signin_alarm" {
  alarm_name                = "RootSignInAlarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "RootSignInCount"
  namespace                 = var.log_metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Root signin has been made"
  alarm_actions             = [var.alarm_sns_topic]
  insufficient_data_actions = []
}
