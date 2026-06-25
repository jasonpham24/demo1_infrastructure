output "application_name" {
  description = "Elastic Beanstalk application name"
  value       = try(aws_elastic_beanstalk_application.this[0].name, null)
}

output "environment_name" {
  description = "Elastic Beanstalk environment name"
  value       = try(aws_elastic_beanstalk_environment.this[0].name, null)
}

output "environment_url" {
  description = "Elastic Beanstalk environment URL"
  value       = try(aws_elastic_beanstalk_environment.this[0].cname, null)
}
