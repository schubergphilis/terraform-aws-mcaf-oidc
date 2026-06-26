provider "aws" {
  region = "eu-west-1"
}

provider "corefunc" {}

module "github_oidc" {
  source = "../..//modules/github"

  iam_roles = {
    "example-role-branch" = {
      policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

      subject_filters = [
        {
          repository = "MyOrg/MyRepo"
          branch     = "main"
        }
      ]
    }

    "example-role-environment" = {
      policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

      subject_filters = [
        {
          repository  = "MyOrg/MyRepo"
          environment = "prod"
        }
      ]
    }

    # Immutable subject claim format for repositories created after July 15, 2026
    # or that have opted in to immutable subject claims.
    # See: https://docs.github.com/en/actions/reference/openid-connect-reference#immutable-subject-claims
    "example-role-immutable" = {
      policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

      subject_filters = [
        {
          repository  = "MyOrg@123456/MyRepo@456789"
          environment = "prod"
        }
      ]
    }
  }
}
