variable "prefix" {
    description = "Prefix for all resource names"
    type = string
    default = "DS"
}


variable "region" {
  type = string
  description = "Region where resources can be created"
 

}

variable "vpc_cidr" {
  type = string
  description = "CIDR Range of the VPC"
  default = "10.0.0.0/16"
}

variable "subnet_web_cidr" {
  type = string
  description = "CIDR Range of the subnet1"
  default = "10.0.1.0/24"
}


variable "web_instance_size" {
    type = string
    default = "t2.micro"
}

variable "env" {
  type = string
  default = "Dev"
}
variable "owner" {
  type = string
  default = "IT"
}