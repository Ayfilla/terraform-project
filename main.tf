terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

####################
# Variables
####################
variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "project_name" {
  type    = string
  default = "tf-demo"
}

####################
# Security Group
####################
resource "aws_security_group" "demo_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH access"

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

####################
# EC2 Instance
####################
resource "aws_instance" "demo" {
  ami             = "ami-08c40ec9ead489470"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.demo_sg.name]

  tags = {
    Name = "${var.project_name}-ec2"
  }
}

####################
# Outputs
####################
output "ec2_public_ip" {
  value = aws_instance.demo.public_ip
}

output "ec2_instance_id" {
  value = aws_instance.demo.id
}

