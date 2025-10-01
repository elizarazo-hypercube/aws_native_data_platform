resource "aws_s3_bucket" "sage_maker_projects" {
  bucket = "sage-maker-projects-${var.environment}-${var.company_name}"
}