cidr_block = "10.10.0.0/16"
subnet1a_cidr_block = "10.10.1.0/24"
subnet1b_cidr_block = "10.10.2.0/24"
subnet1a_availability_zone = "us-east-2a"
subnet1b_availability_zone = "us-east-2b"
map_public_ip_on_launch = "true"
ingress_rules = [
  {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]
egress_rules = [
  {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
]
ami_id = "ami-0b8b44ec9a8f90422"
instance_type = "t2.micro"
user_data_script = <<-EOF
                       #!/bin/bash
                       apt-get update
                       apt-get install -y nginx
                       systemctl start nginx
                       systemctl enable nginx
                     EOF
                     
