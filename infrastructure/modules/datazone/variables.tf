variable company_name {
  description = "The name of the company or organization."
  type        = string
}

variable environment {
  description = "Environment"
  type        = string
  validation {
    condition     = contains(["test", "production", "development"], var.environment)
    error_message = "Valid values for environment are (development, test, production)."
  }
}

variable git_repo {
  description = "The URL of the Git repository to be used."
  type        = string
}