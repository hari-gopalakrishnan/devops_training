provider "aws" {
  region = var.aws_region
}

#Create security group with firewall rules
resource "aws_security_group" "terraform-sg" {
  name        = var.security_group
  description = "security group for terraform"

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # outbound from jenkis server
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = var.security_group
  }
}

resource "aws_instance" "myTerraformInstance" {
  count         = var.instance_count
  ami           = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  security_groups= [var.security_group]
  tags= {
    Name  = element(var.instance_tags, count.index)
  }
}

# Create Elastic IP address

resource "aws_eip" "myTerraformElasticIP" {
  count         = var.instance_count
  vpc      = true
  instance = aws_instance.myTerraformInstance[count.index].id
tags= {
    Name = element(var.instance_tags, count.index)
  }
}