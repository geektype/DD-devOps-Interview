resource "aws_cloudwatch_log_metric_filter" "unauthorised_api_call_filter" {
  name           = "unauthorisedAPICallFilter"
  pattern        = <<pattern
{($.errorCode = "*UnauthorizedOperation") || ($.errorCode = "AccessDenied*")}
pattern
  log_group_name = aws_cloudwatch_log_group.ct-lg.name

  metric_transformation {
    name      = "unAuthorisedAPICallsCount"
    namespace = var.log_metric_namespace
    value     = 1
  }
}


resource "aws_cloudwatch_metric_alarm" "unauthorised_api_call_alarm" {
  alarm_name                = "unauthorisedAPICallAlarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "unAuthorisedAPICallsCount"
  namespace                 = var.log_metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Too many UNAUTHORISED API calls have been made."
  alarm_actions             = [var.alarm_sns_topic]
  insufficient_data_actions = []
}
