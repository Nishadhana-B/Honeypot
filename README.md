Overview

This project deploys a honeypot on AWS to detect unauthorized access attempts and log malicious activities. It integrates AWS SNS for alert notifications and stores logs in an S3 bucket for further analysis.

Features

EC2-based Honeypot: Deploys a virtual instance to capture potential attacks.

Attack Logging: Stores captured attack data in an S3 bucket.

Automated Alerts: Sends notifications via AWS SNS when an attack is detected.

Scalable and Secure: Utilizes AWS IAM roles and policies to ensure security.

Tools & Technologies

AWS EC2 (Instance for the honeypot)

AWS S3 (Storage for attack logs)

AWS SNS (Notification service for alerts)

Terraform (Infrastructure as Code)

Python (Lambda function) (For automated notifications)

Architecture

EC2 Instance: Acts as the honeypot to capture unauthorized access attempts.

S3 Bucket: Stores logs of detected attacks.

SNS Topic: Sends alerts to subscribed users via email.
