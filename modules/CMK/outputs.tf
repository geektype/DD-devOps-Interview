output "cmk_key_arn" {
  description = "ARN of CMK key"
  value       = aws_kms_key.ct-key.arn
}
