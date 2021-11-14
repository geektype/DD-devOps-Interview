resource "aws_cloudwatch_log_metric_filter" "nonMFA_signin" {
  name           = "nonMFASignIn"
  pattern        = <<pattern
{($.eventName = "ConsoleLogin") && ($.additionalEventData.MFAUsed != "Yes")}
pattern
  log_group_name = aws_cloudwatch_log_group.ct-lg.name

  metric_transformation {
    name      = "nonMFASignInCount"
    namespace = var.log_metric_namespace
    value     = 1
  }
}


resource "aws_cloudwatch_metric_alarm" "nonMFA_signin_alarm" {
  alarm_name                = "nonMFASignInAlarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "nonMFASignInCount"
  namespace                 = var.log_metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Too many non-MFA signins have been made."
  alarm_actions             = [var.alarm_sns_topic]
  insufficient_data_actions = []
}
