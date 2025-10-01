# Trust policy
data "aws_iam_policy_document" "amazon_sagemaker_provisioning" {
  statement {
    actions = [
      "sts:AssumeRole",
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
  }
}

# Managed policy
data "aws_iam_policy" "amazon_sagemaker_provisioning" {
  name = "SageMakerStudioProjectProvisioningRolePolicy"
}

resource "aws_iam_role" "amazon_sagemaker_provisioning" {
  assume_role_policy = data.aws_iam_policy_document.amazon_sagemaker_provisioning.json
  name               = "datazone_provisioning_role-${var.environment}"
}

resource "aws_iam_role_policy_attachment" "amazon_sagemaker_provisioning" {
  policy_arn = data.aws_iam_policy.amazon_sagemaker_provisioning.arn
  role       = aws_iam_role.amazon_sagemaker_provisioning.name
}