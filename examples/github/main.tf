provider "aws" {
  region = "eu-west-1"
}

module "github_oidc" {
  source = "../..//modules/github"

  iam_roles = {
    "example-role" = {
      policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

      subject_filter = {
        repository = "MyOrg/MyRepo"
        branch     = "main"
      }
    }
  }
}
