terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"  # Change to your preferred region
}

resource "aws_key_pair" "my_key" {
  key_name   = "my-key-pair"
  public_key = file("my-key-pair.pem.pub")
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  
  ingress {
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

resource "aws_instance" "my_ec2" {
  ami           = "ami-01376101673c89611"  # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"

  key_name      = aws_key_pair.my_key.key_name

  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "MyEC2Instance"
  }
}

output "instance_public_ip" {
  description = "The public IP of the web server"
  value       = aws_instance.my_ec2.public_ip
}
