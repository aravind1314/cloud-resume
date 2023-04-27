variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
    default = "10.0.10.0/24"
}

variable "env_prefix" {
    default = "dev"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "avail_zone" {
    default = "ap-south-1a"
}

variable "aws_region" {
    default = "ap-south-1"
}