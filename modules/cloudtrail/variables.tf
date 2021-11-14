variable "trail_bucket" {
  type        = string
  description = "S3 bucket for trail logs"
}

variable "CMK_key" {
  type        = string
  description = "CMK Key for log encryption"
}

variable "cloud_watch_logs_group" {
  type        = string
  description = "Cloud Watch Log group"
}

variable "region" {
  type        = string
  description = "Region"
}
