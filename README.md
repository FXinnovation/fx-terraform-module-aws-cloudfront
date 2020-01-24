# terraform-module-aws-cloudfront

Terraform module to allow you to create a cloudfront distribution

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | >= 2.34.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aliases | List of extra CNAMEs (alternate domain names), if any, for this distribution. | `list(string)` | n/a | yes |
| bucket\_arn | ARN of the bucket that will be used as origin for cloudfront. Leave this empty if you handle access to the bucket or if the origin isn't a bucket. | `string` | `""` | no |
| cloudfront\_distribution\_enabled | Whether AWS should enabled the cloudfront distribution or not. *Note: Changing this will not affect the existence of the terraform resource.\* | `bool` | `true` | no |
| cloudfront\_distribution\_tags | Map of tags to add on the cloudfront distribution. | `map` | `{}` | no |
| comment | Any comments you want to include about the distribution. | `string` | n/a | yes |
| custom\_error\_response | One or more [custom error response](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#custom-error-response-arguments) elements (multiples allowed). | <pre>list(object({<br>    error_code            = number<br>    error_caching_min_ttl = any<br>    response_code         = any<br>    response_page_path    = any<br>  }))</pre> | `[]` | no |
| default\_cache\_behavior | The default [cache behavior](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#default-cache-behavior-arguments) for this distribution (maximum one). | <pre>list(object({<br>    allowed_methods             = list(string)<br>    cached_methods              = list(string)<br>    target_origin_id            = string<br>    viewer_protocol_policy      = string<br>    compress                    = any<br>    default_ttl                 = any<br>    field_level_encryption_id   = any<br>    lambda_function_association = any<br>    path_pattern                = any<br>    max_ttl                     = any<br>    min_ttl                     = any<br>    smooth_streaming            = any<br>    trusted_signers             = any<br>    forwarded_values = list(object({<br>      query_string            = string<br>      headers                 = any<br>      query_string_cache_keys = any<br>      cookies = list(object({<br>        forward           = string<br>        whitelisted_names = any<br>      }))<br>    }))<br>  }))</pre> | n/a | yes |
| default\_root\_object | The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL. | `string` | n/a | yes |
| enabled | Whether to enabled or disable the module. | `bool` | `true` | no |
| http\_version | The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. | `string` | n/a | yes |
| is\_ipv6\_enabled | Whether the IPv6 is enabled for the distribution. | `bool` | n/a | yes |
| logging\_config | The [logging configuration](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#logging-config-arguments) that controls how logs are written to your distribution (maximum one). | <pre>list(object({<br>    bucket          = string<br>    include_cookies = any<br>    prefix          = any<br>  }))</pre> | `[]` | no |
| ordered\_cache\_behavior | An ordered list of [cache behaviors](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#cache-behavior-arguments) resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0. | <pre>list(object({<br>    allowed_methods             = list(string)<br>    cached_methods              = list(string)<br>    path_pattern                = string<br>    target_origin_id            = string<br>    viewer_protocol_policy      = string<br>    compress                    = any<br>    default_ttl                 = any<br>    field_level_encryption_id   = any<br>    lambda_function_association = any<br>    max_ttl                     = any<br>    min_ttl                     = any<br>    smooth_streaming            = any<br>    trusted_signers             = any<br>    forwarded_values = list(object({<br>      query_string            = string<br>      headers                 = any<br>      query_string_cache_keys = any<br>      cookies = list(object({<br>        forward           = string<br>        whitelisted_names = any<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |
| origin\_groups | One or more [origin\_group](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#origin-group-arguments) for this distribution (multiples allowed). | <pre>list(object({<br>    origin_id = string<br>    failover_criteria = list(object({<br>      status_codes = list(number)<br>    }))<br>    member = list(object({<br>      origin_id = string<br>    }))<br>  }))</pre> | `[]` | no |
| origins | One or more [origins}(https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#origin-arguments) for this distribution (multiples allowed). | <pre>list(object({<br>    domain_name          = string<br>    origin_id            = string<br>    custom_header        = any<br>    origin_path          = any<br>    s3_origin_config     = any<br>    custom_origin_config = any<br>  }))</pre> | `[]` | no |
| price\_class | The price class for this distribution. One of PriceClass\_All, PriceClass\_200, PriceClass\_100. | `string` | n/a | yes |
| restrictions | The [restriction configuration](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#restrictions-arguments) for this distribution (maximum one). | <pre>list(object({<br>    restriction_type = string<br>    locations        = any<br>  }))</pre> | <pre>[<br>  {<br>    "locations": null,<br>    "restriction_type": "none"<br>  }<br>]</pre> | no |
| retain\_on\_delete | Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards. | `bool` | `false` | no |
| tags | Map of tags to add to all resources. | `map` | `{}` | no |
| viewer\_certificate | The [SSL configuration](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#viewer-certificate-arguments) for this distribution (maximum one). | <pre>list(object({<br>    acm_certificate_arn            = any<br>    cloudfront_default_certificate = any<br>    iam_certificate_id             = any<br>    minimum_protocol_version       = any<br>    ssl_support_method             = any<br>  }))</pre> | n/a | yes |
| wait\_for\_deployment | If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process. | `bool` | `true` | no |
| web\_acl\_id | If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of the Cloudformation Distribution. |
| caller\_reference | Internal value used by CloudFront to allow future updates to the distribution configuration. |
| domain\_name | The domain name corresponding to the distribution. |
| etag | The domain name corresponding to the distribution. |
| hosted\_zone\_id | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. This attribute is simply an alias for the zone ID Z2FDTNDATAQYW2. |
| id | ID of the Cloudformation Distribution. |
| s3\_iam\_policy\_document | IAM policy document to set on the bucket for Cloudfront to be able to access it. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
