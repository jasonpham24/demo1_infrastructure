resource "aws_elastic_beanstalk_application" "this" {
  name        = var.application_name
  description = "Elastic Beanstalk application for ${var.application_name}"
  tags        = merge({ Name = var.application_name }, var.tags)
}

resource "aws_elastic_beanstalk_application_version" "this" {
  count = var.application_version_bucket != "" && var.application_version_key != "" && var.application_version_label != "" ? 1 : 0

  application = aws_elastic_beanstalk_application.this.name
  name        = var.application_version_label
  bucket      = var.application_version_bucket
  key         = var.application_version_key
}

resource "aws_elastic_beanstalk_environment" "this" {
  count = var.environment_name != "" && var.application_version_label != "" ? 1 : 0

  name                = var.environment_name
  application         = aws_elastic_beanstalk_application.this.name
  solution_stack_name = var.solution_stack_name
  tier                = var.environment_tier
  version_label       = var.application_version_label

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.environment_instance_type
  }

  tags = merge({ Name = var.environment_name }, var.tags)
}
