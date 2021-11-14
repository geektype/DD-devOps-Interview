terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.65.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project = var.project
    }
  }
}

module "CMK_key" {
  source = "./modules/CMK"
}

module "sns" {
  source = "./modules/SNS"

  target_emails = var.target_emails
}

module "cloudwatch" {
  source = "./modules/cloud_watch"

  log_metric_namespace = var.log_namespace
  alarm_sns_topic      = module.sns.sns_topic_arn
}

module "s3_buckets" {
  source = "./modules/s3_buckets"

  trail-bucket-name = var.trail-bucket-name
  log-bucket-name   = var.log-bucket-name
}

module "CloudTrail" {
  source                 = "./modules/cloudtrail"
  trail_bucket           = module.s3_buckets.trail_bucket_id
  CMK_key                = module.CMK_key.cmk_key_arn
  cloud_watch_logs_group = module.cloudwatch.cloud_watch_log_group
  region                 = var.region
}

