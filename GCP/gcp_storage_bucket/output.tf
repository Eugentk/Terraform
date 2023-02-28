#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# Output.tf file
#
# Made by Tk.eugen@gmail.com
#-----------------------------------------------------------------------------------------
output "storage_bucket_name" {
  description = "Name of google storage bucket"
  value       = google_storage_bucket.bucket.*.name
}

output "storage_bucket_self_link" {
  description = "storage bucket link"
  value       = google_storage_bucket.bucket.*.self_link
}

output "storage_bucket_url" {
  description = "storage bucket URL"
  value = google_storage_bucket.bucket.*.url
}
