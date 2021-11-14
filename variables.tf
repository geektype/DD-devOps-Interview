variable "region" {
  type        = string
  description = "Home Region"
  default     = "us-east-1"
}

variable "project" {
  type        = string
  description = "Project Namae"
  default     = "DevOps-Interview"
}

variable "trail-bucket-name" {
  type        = string
  description = "Trail Bucket Name"
  default     = "dd-interview-trail-bucket"
}


variable "log-bucket-name" {
  type        = string
  description = "Log Bucket Name"
  default     = "dd-interview-log-bucket"
}

variable "log_namespace" {
  type        = string
  description = "Namespace for log metrics"
  default     = "CT/trail"
}

variable "target_emails" {
  type        = list(string)
  description = "List of emails to set up as subscribers"
  default = [
    "admin@company.com",
    "monitoring@company.com"
  ]
}
