
provider "aws" {
region  = "us-east-1"
}

variable "zones_east" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "zones_east-1" {
  default = ["us-east-1c", "us-east-1d"]
}


resource "aws_instance" "east_frontend" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "t2.micro"
  availability_zone = var.zones_east[count.index]
  count             = 2
  depends_on    = [ aws_instance.east_backend ]
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "east-front-${count.index}"
    Team = "DevOps"
  }
}

resource "aws_instance" "west_frontend" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "t2.micro"
  availability_zone = var.zones_east-1[count.index]
  count             = 2
  depends_on    = [ aws_instance.west_backend ]
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "west-front-${count.index}"
    Team = "DevOps"
  }
}


resource "aws_instance" "east_backend" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "t2.micro"
  availability_zone = var.zones_east[count.index]
  count             = 2
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "east-back-${count.index}"
    Team = "DevOps"
  }
}


resource "aws_instance" "west_backend" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "t2.micro"
  availability_zone = var.zones_east-1[count.index]
  count             = 2
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "west-back-${count.index}"
    Team = "DevOps"
}
}

output "PublicIP_East_Frontend" {
  value = aws_instance.east_frontend.*.public_ip
}

output "PublicIP_East_Backend" {
  value = aws_instance.east_backend.*.public_ip
}