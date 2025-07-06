resource "aws_sns_topic" "alert_system_topic" {
  name = "alert-system-topic"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alert_system_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email  # Email address where alerts will be sent
}

output "sns_topic_arn" {
  value = aws_sns_topic.alert_system_topic.arn
  description = "ARN of the SNS topic for alert notifications"
  
}