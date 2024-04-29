variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "subnet1a_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}
variable "subnet1b_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}
variable "subnet1a_availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
}
variable "subnet1b_availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
}
variable "map_public_ip_on_launch" {
  description = "Boolean indicating whether instances launched into this subnet should have public IP addresses"
  type        = bool
}
variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
variable "egress_rules" {
  description = "List of egress rules for the security group"
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
}
variable "ami_id" {
  description = "The ID of the AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to launch"
  type        = string
}

variable "user_data_script" {
  description = "The user data script to run on instance launch"
  type        = string
}


