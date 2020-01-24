#####
# Locals
#####

locals {
  tags = {
    "Terraform" = "true"
  }
}

#####
# Datasources
#####

data "aws_iam_policy_document" "s3_policy" {
  count = var.enabled && "" != var.bucket_arn ? 1 : 0

  statement {
    actions   = ["s3:GetObject"]
    resources = var.bucket_arn

    principals {
      type        = "AWS"
      identifiers = [element(concat(aws_cloudfront_origin_access_identity.this.*.iam_arn, [""]), 0)]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = var.bucket_arn

    principals {
      type        = "AWS"
      identifiers = [element(concat(aws_cloudfront_origin_access_identity.this.*.iam_arn, [""]), 0)]
    }
  }
}

#####
# Cloudfront
#####

resource "aws_cloudfront_distribution" "this" {
  count = var.enabled ? 1 : 0

  enabled             = var.cloudfront_distribution_enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.comment
  default_root_object = var.default_root_object
  aliases             = var.aliases
  price_class         = var.price_class
  http_version        = var.http_version
  web_acl_id          = var.web_acl_id
  retain_on_delete    = var.retain_on_delete
  wait_for_deployment = var.wait_for_deployment

  dynamic "origin_group" {
    for_each = var.origin_groups

    content {
      origin_id = origin_group.value.origin_id

      dynamic "failover_criteria" {
        for_each = origin_group.value.failover_criteria

        content {
          status_codes = failover_criteria.value.status_codes
        }
      }

      dynamic "member" {
        for_each = origin_group.value.members

        content {
          origin_id = member.value.origin_id
        }
      }
    }
  }

  dynamic "origin" {
    for_each = var.origins

    content {
      domain_name   = origin.value.domain_name
      origin_id     = origin.value.origin_id
      custom_header = lookup(origin.value, "custome_header", null)
      origin_path   = lookup(origin.value, "origin_path", null)

      dynamic "s3_origin_config" {
        for_each = lookup(origin.value, "s3_origin_config", [])

        content {
          origin_access_identity = "" != var.bucket_arn ? element(concat(aws_cloudfront_origin_access_identity.this.*.cloudfront_access_identity_path, [""]), 0) : lookup(s3_origin_config.value, "origin_access_identity", null)
        }
      }

      dynamic "custom_origin_config" {
        for_each = lookup(origin.value, "custom_origin_config", [])

        content {
          http_port                = lookup(custom_origin_config.value, "http_port", 80)
          https_port               = lookup(custom_origin_config.value, "https_port", 443)
          origin_protocol_policy   = lookup(custom_origin_config.value, "origin_protocol_policy", "match-viewer")
          origin_ssl_protocols     = lookup(custom_origin_config.value, "origin_ssl_protocols", ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"])
          origin_keepalive_timeout = lookup(custom_origin_config.value, "origin_keepalive_timeout", null)
          origin_read_timeout      = lookup(custom_origin_config.value, "origin_read_timeout", null)
        }
      }
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_config

    content {
      bucket          = logging_config.value.bucket
      include_cookies = lookup(logging_config.value, "include_cookies", null)
      prefix          = lookup(logging_config.value, "prefix", null)
    }
  }

  dynamic "default_cache_behavior" {
    for_each = var.default_cache_behavior

    content {
      allowed_methods           = default_cache_behavior.value.allowed_methods
      cached_methods            = default_cache_behavior.value.cached_methods
      target_origin_id          = default_cache_behavior.value.target_origin_id
      viewer_protocol_policy    = default_cache_behavior.value.viewer_protocol_policy
      compress                  = lookup(default_cache_behavior.value, "compress", null)
      default_ttl               = lookup(default_cache_behavior.value, "default_ttl", null)
      field_level_encryption_id = lookup(default_cache_behavior.value, "field_level_encryption_id", null)
      path_pattern              = lookup(default_cache_behavior.value, "path_pattern", null)
      max_ttl                   = lookup(default_cache_behavior.value, "max_ttl", null)
      min_ttl                   = lookup(default_cache_behavior.value, "min_ttl", null)
      smooth_streaming          = lookup(default_cache_behavior.value, "smooth_streaming", null)
      trusted_signers           = lookup(default_cache_behavior.value, "trusted_signers", null)

      dynamic "forwarded_values" {
        for_each = var.forwared_values

        content {
          query_string            = forwarded_values.value.query_string
          headers                 = lookup(forwarded_values.value, "headers", null)
          query_string_cache_keys = ookup(forwarded_values.value, "query_string_cache_keys", null)

          dynamic "cookie" {
            for_each = orwarded_values.value.cookies

            content {
              forward           = cookie.value.forward
              whitelisted_names = lookup(cookie.value, "whitelisted_names", null)
            }
          }
        }
      }

      dynamic "lambda_function_association" {
        for_each = lookup(default_cache_behavior.value, "lambda_function_associations", [])

        content {
          event_type   = lambda_function_association.value.event_type
          lambda_arn   = lambda_function_association.value.lambda_arn
          include_body = lookup(lambda_function_association.value, "include_body", null)
        }
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behaviors

    content {
      allowed_methods           = ordered_cache_behavior.value.allowed_methods
      cached_methods            = ordered_cache_behavior.value.cached_methods
      path_pattern              = ordered_cache_behavior.value.path_pattern
      target_origin_id          = ordered_cache_behavior.value.target_origin_id
      viewer_protocol_policy    = ordered_cache_behavior.value.viewer_protocol_policy
      compress                  = lookup(ordered_cache_behavior.value, "compress", null)
      default_ttl               = lookup(default_cache_behavior.value, "default_ttl", null)
      field_level_encryption_id = lookup(ordered_cache_behavior.value, "field_level_encryption_id", null)
      max_ttl                   = lookup(ordered_cache_behavior.value, "max_ttl", null)
      min_ttl                   = lookup(ordered_cache_behavior.value, "min_ttl", null)
      smooth_streaming          = lookup(ordered_cache_behavior.value, "smooth_streaming", null)
      trusted_signers           = lookup(ordered_cache_behavior.value, "trusted_signers", null)

      dynamic "forwarded_values" {
        for_each = var.forwared_values

        content {
          query_string            = forwarded_values.value.query_string
          headers                 = lookup(forwarded_values.value, "headers", null)
          query_string_cache_keys = ookup(forwarded_values.value, "query_string_cache_keys", null)

          dynamic "cookie" {
            for_each = orwarded_values.value.cookies

            content {
              forward           = cookie.value.forward
              whitelisted_names = lookup(cookie.value, "whitelisted_names", null)
            }
          }
        }
      }

      dynamic "lambda_function_association" {
        for_each = lookup(default_cache_behavior.value, "lambda_function_associations", [])

        content {
          event_type   = lambda_function_association.value.event_type
          lambda_arn   = lambda_function_association.value.lambda_arn
          include_body = lookup(lambda_function_association.value, "include_body", null)
        }
      }
    }
  }

  dynamic "restrictions" {
    for_each = var.restrictions

    content {
      restriction_type = restrictions.value.restriction_type
      locations        = lookup(restrictions.value, "locations", null)
    }
  }

  dynamic "viewer_certificate" {
    for_each = var.viewer_certificate

    content {
      acm_certificate_arn            = lookup(viewer_certificate.value, "acm_certificate_arn", null)
      cloudfront_default_certificate = lookup(viewer_certificate.value, "cloudfront_default_certificate", null)
      iam_certificate_id             = lookup(viewer_certificate.value, "iam_certificate_id", null)
      minimum_protocol_version       = lookup(viewer_certificate.value, "minimum_protocol_version", null)
      ssl_support_method             = lookup(viewer_certificate.value, "ssl_support_method", null)
    }
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses

    content {
      error_code            = custom_error_response.value.error_code
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", null)
      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
    }
  }

  tags = merge(
    local.tags,
    var.tags,
    var.cloudfront_distribution_tags
  )
}

resource "aws_cloudfront_origin_access_identity" "this" {
  count = var.enabled && "" != var.bucket_arn ? 1 : 0

  comment = "Origin access identity for ${var.bucket_arn}."
}
