resource "aws_sns_topic_subscription" "email_sub" {
  count     = length(var.target_emails)
  topic_arn = aws_sns_topic.ct-alert-topic.arn
  protocol  = "email"
  endpoint  = var.target_emails[count.index]
}
