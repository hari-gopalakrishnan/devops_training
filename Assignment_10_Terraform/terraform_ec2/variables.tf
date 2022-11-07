variable "aws_region" {
       description = "The AWS region to create things in."
       default     = "us-east-1"
}

variable "instance_count" {
  default = "3"
}

variable "key_name" {
    description = " SSH keys to connect to ec2 instance"
    default     =  "Terraform_Keypair"
}

variable "instance_type" {
    description = "instance type for ec2"
    default     =  "t2.micro"
}

variable "security_group" {
    description = "Name of security group"
    default     = "terraform-sg"
}

variable "instance_tags" {
  type = list
  default = ["hari-tf-1", "hari-tf-2", "hari-tf-3"]
}

variable "ami_id" {
    description = "AMI for Ubuntu Ec2 instance"
    default     = "ami-0cff7528ff583bf9a"
}