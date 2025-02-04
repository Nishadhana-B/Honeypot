# AWS Provider Configuration
provider "aws" {
  region = "us-east-1"  # Change to your preferred AWS region
}

# EC2 Instance Setup (Honeypot)
resource "aws_instance" "honeypot" {
  ami           = "ami-0003e973f06d4cf59"  # Change this to your region's AMI ID
  instance_type = "t2.micro"
  tags = {
    Name = "Honeypot-Instance"
  }
}

# S3 Bucket Setup for Attack Logs
resource "aws_s3_bucket" "attack_logs" {
  bucket = "nisha2345"  # Change this to a unique name
}

# SNS Topic Setup for Alerts
resource "aws_sns_topic" "honeypot_alerts" {
  name = "honeypot-alerts"
}

# SNS Email Subscription for Alerting
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.honeypot_alerts.arn
  protocol  = "email"
  endpoint  = "nishadhana.profiles@gmail.com"  # Change this to your actual email
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Lambda to access SNS
resource "aws_iam_policy" "sns_policy" {
  name        = "sns_policy"
  description = "Allow Lambda to publish to SNS"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sns:Publish"
        Effect    = "Allow"
        Resource  = aws_sns_topic.honeypot_alerts.arn
      }
    ]
  })
}

# Attach the IAM Policy to the Lambda Execution Role
resource "aws_iam_role_policy_attachment" "lambda_sns" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.sns_policy.arn
}

# Lambda Function to Send Alerts
resource "aws_lambda_function" "honeypot_alert" {
  filename      = "lambda_function.zip"  # Your Lambda zip file
  function_name = "HoneypotAlertLambda"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.honeypot_alerts.arn
    }
  }
}

