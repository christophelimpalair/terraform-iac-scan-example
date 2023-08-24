provider "aws" {
  region = "us-west-1"
  # Removing hardcoded credentials; it's recommended to use AWS CLI's credential configuration or IAM roles.
}

resource "aws_s3_bucket" "good_bucket" {
  bucket = "my-good-bucket"
  acl    = "private" # Making the bucket private

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256" # Enable server-side encryption
      }
    }
  }

  tags = {
    Name = "good_bucket"
  }
}

resource "aws_security_group" "good_sg" {
  name        = "good_sg"
  description = "A security group with tight rules"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.8.8/32"] # Replace with a specific trusted IP.
    description = "Allow only specific inbound traffic, for example SSH"
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = " Allow all outbound traffic (Common practice, but can be restricted further if necessary)"
  }

  tags = {
    Name = "good_sg"
  }
}

resource "aws_instance" "good_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  monitoring    = true # Enable detailed monitoring

  ebs_optimized = true # Enable EBS optimization

  metadata_options { # Enable IMDSv2
    http_endpoint   = "enabled"
    http_tokens     = "required"
  }

  # Encrypted root volume
  root_block_device {
    volume_type = "gp2"
    volume_size = 10
    encrypted   = true # Enable encryption
  }

  tags = {
    Name = "good_instance"
  }
}
