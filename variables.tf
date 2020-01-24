#####
# Global
#####

variable "bucket_arn" {
  description = "ARN of the bucket that will be used as origin for cloudfront. Leave this empty if you handle access to the bucket or if the origin isn't a bucket."
  default     = ""
}

variable "enabled" {
  description = "Whether to enabled or disable the module."
  default     = true
}

variable "tags" {
  description = "Map of tags to add to all resources."
  default     = {}
}


#####
# Cloudfront Distribution
#####

variable "aliases" {
  description = "List of extra CNAMEs (alternate domain names), if any, for this distribution."
  type        = list(string)
  default     = null
}

variable "cloudfront_distribution_enabled" {
  description = "Whether AWS should enabled the cloudfront distribution or not. *Note: Changing this will not affect the existence of the terraform resource.*"
  default     = true
}

variable "cloudfront_distribution_tags" {
  description = "Map of tags to add on the cloudfront distribution."
  default     = {}
}

variable "comment" {
  description = "Any comments you want to include about the distribution."
  default     = null
  type        = string
}

variable "custom_error_response" {
  description = "One or more [custom error response](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#custom-error-response-arguments) elements (multiples allowed)."
  default     = []
  type = list(object({
    error_code            = number
    error_caching_min_ttl = any
    response_code         = any
    response_page_path    = any
  }))
}

variable "default_root_object" {
  description = "The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
  default     = null
  type        = string
}

variable "default_cache_behavior" {
  description = "The default [cache behavior](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#default-cache-behavior-arguments) for this distribution (maximum one)."
  type = list(object({
    allowed_methods             = list(string)
    cached_methods              = list(string)
    target_origin_id            = string
    viewer_protocol_policy      = string
    compress                    = any
    default_ttl                 = any
    field_level_encryption_id   = any
    lambda_function_association = any
    path_pattern                = any
    max_ttl                     = any
    min_ttl                     = any
    smooth_streaming            = any
    trusted_signers             = any
    forwarded_values = list(object({
      query_string            = string
      headers                 = any
      query_string_cache_keys = any
      cookies = list(object({
        forward           = string
        whitelisted_names = any
      }))
    }))
  }))
}

variable "ordered_cache_behavior" {
  description = "An ordered list of [cache behaviors](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#cache-behavior-arguments) resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0."
  default     = []
  type = list(object({
    allowed_methods             = list(string)
    cached_methods              = list(string)
    path_pattern                = string
    target_origin_id            = string
    viewer_protocol_policy      = string
    compress                    = any
    default_ttl                 = any
    field_level_encryption_id   = any
    lambda_function_association = any
    max_ttl                     = any
    min_ttl                     = any
    smooth_streaming            = any
    trusted_signers             = any
    forwarded_values = list(object({
      query_string            = string
      headers                 = any
      query_string_cache_keys = any
      cookies = list(object({
        forward           = string
        whitelisted_names = any
      }))
    }))
  }))
}

variable "http_version" {
  description = "The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2."
  default     = null
  type        = string
}

variable "is_ipv6_enabled" {
  description = "Whether the IPv6 is enabled for the distribution."
  default     = null
  type        = bool
}

variable "logging_config" {
  description = "The [logging configuration](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#logging-config-arguments) that controls how logs are written to your distribution (maximum one)."
  default     = []
  type = list(object({
    bucket          = string
    include_cookies = any
    prefix          = any
  }))
}

variable "origins" {
  description = "One or more [origins}(https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#origin-arguments) for this distribution (multiples allowed)."
  default     = []
  type = list(object({
    domain_name          = string
    origin_id            = string
    custom_header        = any
    origin_path          = any
    s3_origin_config     = any
    custom_origin_config = any
  }))
}

variable "origin_groups" {
  description = "One or more [origin_group](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#origin-group-arguments) for this distribution (multiples allowed)."
  default     = []
  type = list(object({
    origin_id = string
    failover_criteria = list(object({
      status_codes = list(number)
    }))
    member = list(object({
      origin_id = string
    }))
  }))
}

variable "price_class" {
  description = "The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100."
  default     = null
  type        = string
}

variable "restrictions" {
  description = "The [restriction configuration](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#restrictions-arguments) for this distribution (maximum one)."
  type = list(object({
    restriction_type = string
    locations        = any
  }))
  default = [{
    restriction_type = "none"
    locations        = null
  }]
}

variable "retain_on_delete" {
  description = "Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards."
  default     = false
}

variable "viewer_certificate" {
  description = "The [SSL configuration](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#viewer-certificate-arguments) for this distribution (maximum one)."
  type = list(object({
    acm_certificate_arn            = any
    cloudfront_default_certificate = any
    iam_certificate_id             = any
    minimum_protocol_version       = any
    ssl_support_method             = any
  }))
}

variable "wait_for_deployment" {
  description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process."
  default     = true
}

variable "web_acl_id" {
  description = "If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned."
  default     = null
  type        = string
}
