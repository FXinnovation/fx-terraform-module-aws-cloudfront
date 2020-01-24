output "arn" {
  description = "ARN of the Cloudformation Distribution."
  value       = element(concat(aws_cloudfront_distribution.this.*.arn, [""]), 0)
}

output "caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration."
  value       = element(concat(aws_cloudfront_distribution.this.*.caller_reference, [""]), 0)
}

output "domain_name" {
  description = "The domain name corresponding to the distribution."
  value       = element(concat(aws_cloudfront_distribution.this.*.domain, [""]), 0)
}

output "etag" {
  description = "The domain name corresponding to the distribution."
  value       = element(concat(aws_cloudfront_distribution.this.*.etag, [""]), 0)
}

output "id" {
  description = "ID of the Cloudformation Distribution."
  value       = element(concat(aws_cloudfront_distribution.this.*.id, [""]), 0)
}

output "hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. This attribute is simply an alias for the zone ID Z2FDTNDATAQYW2."
  value       = element(concat(aws_cloudfront_distribution.this.*.hosted_zone_id, [""]), 0)
}

output "s3_iam_policy_document" {
  description = "IAM policy document to set on the bucket for Cloudfront to be able to access it."
  value       = element(concat(data.aws_iam_policy_document.s3_policy.*.json, [""]), 0)
}
