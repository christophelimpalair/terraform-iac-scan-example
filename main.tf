# This code is PURPOSELY BADLY WRITTEN for educational purposes! Do not copy/paste this for any sort of production use, as this is bad security design
provider "aws" {
  region = "us-west-1"
  access_key = "AKIAIOSFODNN7EXAMPLE" # Hardcoded credentials
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
}

resource "aws_s3_bucket" "bad_bucket" {
  bucket = "my-bad-bucket"
  acl    = "public-read" # Public S3 bucket

  tags = {
    Name = "bad_bucket"
  }
}

resource "aws_security_group" "bad_sg" {
  name        = "bad_sg"
  description = "A security group with overly permissive rules"

  # Allow all inbound traffic
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bad_sg"
  }
}

resource "aws_instance" "bad_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  # No encryption
  root_block_device {
    volume_type = "gp2"
    volume_size = 10
  }

  tags = {
    Name = "bad_instance"
  }
}