data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "myTrail"
  s3_bucket_name                = var.trail_bucket
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  kms_key_id                    = var.CMK_key
  cloud_watch_logs_group_arn    = "${var.cloud_watch_logs_group}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.ct-cw-role.arn
}



