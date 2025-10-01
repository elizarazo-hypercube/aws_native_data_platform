# Trust policy
data "aws_iam_policy_document" "amazon_sagemaker_query_execution" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:SetContext"
    ]
    principals {
      type = "Service"
      identifiers = [
        "glue.amazonaws.com",
        "lakeformation.amazonaws.com"
      ]
    }
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "aws:SourceAccount"
    }
  }
}

# Managed policy
data "aws_iam_policy" "amazon_sagemaker_query_execution" {
  name = "SageMakerStudioQueryExecutionRolePolicy"
}

resource "aws_iam_role" "amazon_sagemaker_query_execution" {
  assume_role_policy = data.aws_iam_policy_document.amazon_sagemaker_query_execution.json
  name               = "datazone_query_execution_role-${var.environment}"
}

resource "aws_iam_role_policy_attachment" "amazon_sagemaker_query_execution" {
  policy_arn = data.aws_iam_policy.amazon_sagemaker_query_execution.arn
  role       = aws_iam_role.amazon_sagemaker_query_execution.name
}
