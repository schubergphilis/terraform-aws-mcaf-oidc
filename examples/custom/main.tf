provider "aws" {
  region = "eu-west-1"
}

provider "corefunc" {}

module "custom_oidc" {
  source = "../.."

  oidc_provider = {
    client_ids     = ["sts.amazonaws.com"]
    name           = "MyProvider"
    thumbprint_url = "https://example-domain.com/.well-known/openid-configuration"
    url            = "https://example-domain.com"
  }

  iam_roles = {
    "example-role" = {
      policy_arns     = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
      subject_filters = ["1234567890"]
    }
  }
}
