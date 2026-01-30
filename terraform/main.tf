provider "aws" {
  region = "us-east-1"
}

# Default VPC
resource "aws_default_vpc" "vpc" {}

# Key Pair
resource "aws_key_pair" "key" {
  key_name   = "terra-key"
  public_key = file("terra-key.pub")
}

# Security Group
resource "aws_security_group" "sg" {
  name        = "Terraform-SG"
  description = "Allow SSH, HTTP, HTTPS"
  vpc_id      = aws_default_vpc.vpc.id

  # SSH
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound (required)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-SG"
  }
}

# EC2 Instance
resource "aws_instance" "ec2" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name    = "Terraform-EC2"
    Project = "Terraform"
  }
}
