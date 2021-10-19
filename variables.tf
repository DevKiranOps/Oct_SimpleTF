variable "prefix" {
    description = "Prefix for all resource names"
    type = string
    default = "DS"
}


variable "region" {
  type = string
  description = "Region where resources can be created"
 
}


// variable "Public_subnet_CIDR" {
//   type = list
// }

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


variable "subnet_bastion_cidr" {
  type = string
  description = "CIDR Range of the subnet1"
  default = "10.0.3.0/24"
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
  # default = "IT"
}

variable "instance_count" {
  type = number
  default = 4
}

variable "bastion_instance_size" {


  
}
variable "keypair" {
  description = "Keypair for authentication"
  default = "cloudopsuseast1"
}

variable "public_subnet_CIDRs" { 
  type = list 
  default = [
    "10.10.10.0/24",
    "10.10.20.0/24",
    "10.10.30.0/24",
    "10.10.40.0/24",
    "10.10.50.0/24",
    "10.10.60.0/24"
  ]

}

variable "web_subnet_CIDRs" { 
  type = list 
  default = [
    "10.10.5.0/24",
    "10.10.15.0/24",
    "10.10.25.0/24",
    "10.10.35.0/24",
    "10.10.45.0/24",
    "10.10.55.0/24"
  ]

}