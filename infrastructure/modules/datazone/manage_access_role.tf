# Trust policy
data "aws_iam_policy_document" "amazon_sagemaker_manage_access_trust_policy" {
  statement {

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["datazone.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_datazone_domain.this.arn]
    }
  }
}

# Managed policy
data "aws_iam_policy" "amazon_sagemaker_manage_access" {
  name = "AmazonDataZoneSageMakerManageAccessRolePolicy"
}

resource "aws_iam_role" "amazon_sagemaker_manage_access" {
  assume_role_policy = data.aws_iam_policy_document.amazon_sagemaker_manage_access_trust_policy.json
  name               = "datazone_manage_access_role-${var.environment}"
}

resource "aws_iam_role_policy_attachment" "amazon_sagemaker_manage_access" {
  policy_arn = data.aws_iam_policy.amazon_sagemaker_manage_access.arn
  role       = aws_iam_role.amazon_sagemaker_manage_access.name
}

data "aws_iam_policy" "amazon_datazone_glue_manage_access" {
  name = "AmazonDataZoneGlueManageAccessRolePolicy"
}

resource "aws_iam_role_policy_attachment" "amazon_datazone_glue_manage_access" {
  policy_arn = data.aws_iam_policy.amazon_datazone_glue_manage_access.arn
  role       = aws_iam_role.amazon_sagemaker_manage_access.name
}

data "aws_iam_policy" "amazon_datazone_redshift_manage_access" {
  name = "AmazonDataZoneRedshiftManageAccessRolePolicy"
}

resource "aws_iam_role_policy_attachment" "amazon_datazone_redshift_manage_access" {
  policy_arn = data.aws_iam_policy.amazon_datazone_redshift_manage_access.arn
  role       = aws_iam_role.amazon_sagemaker_manage_access.name
}



# Permissions policy
data "aws_iam_policy_document" "redshift_secret_permissions" {
  statement {
    sid    = "RedshiftSecretStatement"
    effect = "Allow"

    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "secretsmanager:ResourceTag/AmazonDataZoneDomain"
      values   = [aws_datazone_domain.this.id]
    }
  }
}

resource "aws_iam_policy" "redshift_secret_permissions" {
  name        = "RedshiftSecretStatement"
  policy      = data.aws_iam_policy_document.redshift_secret_permissions.json
}

resource "aws_iam_role_policy_attachment" "amazon_sagemaker_manage_access_redshift_secret_permission" {
  policy_arn = aws_iam_policy.redshift_secret_permissions.arn
  role       = aws_iam_role.amazon_sagemaker_manage_access.name
}