resource "aws_s3_bucket" "access_log_bucket" {
  bucket = var.log-bucket-name
  acl    = "private"
  tags = {
    Name = var.log-bucket-name
  }
}
