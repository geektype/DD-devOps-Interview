resource "aws_iam_role" "ct-cw-role" {
  name               = "ct-cw-role"
  assume_role_policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
JSON
}

resource "aws_iam_role_policy" "ct-cw-policy" {
  name = "ct-cw-policy"
  role = aws_iam_role.ct-cw-role.id

  policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream2014110",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream"
      ],
      "Resource": [
        "${var.cloud_watch_logs_group}:log-stream:${data.aws_caller_identity.current.account_id}_CloudTrail_${var.region}*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents20141101",
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "${var.cloud_watch_logs_group}:log-stream:${data.aws_caller_identity.current.account_id}_CloudTrail_${var.region}*"
      ]
    }
  ]
}
JSON
}
