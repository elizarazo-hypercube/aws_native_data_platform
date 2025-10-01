data "aws_caller_identity" "current" {}

# Trust policy
data "aws_iam_policy_document" "assume_role_domain_execution" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
      "sts:SetContext"
    ]
    principals {
      type        = "Service"
      identifiers = ["datazone.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "aws:SourceAccount"
    }
    condition {
      test     = "ForAllValues:StringLike"
      values   = ["datazone*"]
      variable = "aws:TagKeys"
    }
  }
}

resource "aws_iam_role" "domain_execution" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_domain_execution.json
  name               = "datazone_domain_execution_role-${var.environment}"
}

# Managed policy
data "aws_iam_policy" "domain_execution_role" {
  name = "SageMakerStudioDomainExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "domain_execution" {
  policy_arn = data.aws_iam_policy.domain_execution_role.arn
  role       = aws_iam_role.domain_execution.name
}

# IAM role for Domain Service
data "aws_iam_policy_document" "assume_role_domain_service" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["datazone.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "aws:SourceAccount"
    }
  }
}

resource "aws_iam_role" "domain_service" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_domain_service.json
  name               = "datazone_domain_service_role-${var.environment}"
}

data "aws_iam_policy" "domain_service_role" {
  name = "SageMakerStudioDomainServiceRolePolicy"
}

resource "aws_iam_role_policy_attachment" "domain_service" {
  policy_arn = data.aws_iam_policy.domain_service_role.arn
  role       = aws_iam_role.domain_service.name
}

# DataZone Domain V2
resource "aws_datazone_domain" "this" {
  name                  = "${var.company_name}-dataplatform-${var.environment}"
  domain_execution_role = aws_iam_role.domain_execution.arn
  domain_version        = "V2"
  service_role          = aws_iam_role.domain_service.arn
}