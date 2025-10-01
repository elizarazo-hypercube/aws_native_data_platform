resource "aws_glue_catalog_database" "this" {
    for_each = toset(["bronze"])
    name = "project-${each.key}"
}

# resource "aws_lakeformation_permissions" "test" {
#   principal   = aws_iam_role.sales_role.arn
#   permissions = ["CREATE_TABLE", "ALTER", "DROP"]

#   lf_tag_policy {
#     resource_type = "DATABASE"

#     expression {
#       key    = "Department"
#       values = ["sales"]
#     }

#     expression {
#       key    = "Role"
#       values = ["Analyst", "Scientist"]
#     }
#   }
#   database {
#     name = aws_glue_catalog_database.this["bronze"].name
#   }
# }