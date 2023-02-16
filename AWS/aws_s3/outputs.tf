#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# outputs.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------

output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = aws_s3_bucket.terraform-state-bucket.id
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname"
  value       = aws_s3_bucket.terraform-state-bucket.arn
}