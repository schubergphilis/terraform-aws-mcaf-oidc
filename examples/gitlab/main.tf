provider "aws" {
  region = "eu-west-1"
}

provider "corefunc" {}

module "gitlab_oidc" {
  source = "../..//modules/gitlab"

  iam_roles = {
    "example-role" = {
      policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

      subject_filters = [
        {
          project_path = "mygroup/*"
          ref_type     = "branch"
          ref          = "main"
        }
      ]
    }
  }
}
