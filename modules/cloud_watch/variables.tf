variable "log_metric_namespace" {
  type        = string
  description = "Namespace to put metrics in"
}

variable "alarm_sns_topic" {
  type        = string
  description = "SNS topic to publish the alarm to"
}
