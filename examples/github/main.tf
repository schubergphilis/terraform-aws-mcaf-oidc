provider "aws" {
  region = "eu-west-1"
}

provider "corefunc" {}

module "github_oidc" {
  source = "../..//modules/github"

  iam_roles = {
    "example-role" = {
      policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

      subject_filters = [
        {
          repository = "MyOrg/MyRepo"
          branch     = "main"
        }
      ]
    }
  }
}
