
resource "aws_vpc" "project-vpc" {
  cidr_block = var.cidr_block
}


resource "aws_subnet" "subnet_1a" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = var.subnet1a_cidr_block
  availability_zone = var.subnet1a_availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch


  tags = {
    Name = "subnet-1a"
  }
}

resource "aws_subnet" "subnet_1b" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = var.subnet1b_cidr_block
  availability_zone = var.subnet1b_availability_zone

  tags = {
    Name = "subnet-1b"
  }
}

resource "aws_internet_gateway" "myproject_ig" {
  vpc_id = aws_vpc.project-vpc.id

  tags = {
    Name = "myproject_ig"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.project-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myproject_ig.id
  }

  tags = {
    Name = "rt_public"
  }
}

resource "aws_route_table_association" "associate-1a-rt" {
  subnet_id      = aws_subnet.subnet_1a.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_security_group" "project" {
  name        = "project-80"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.project-vpc.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
    }
  }
  tags = {
    Name = "allow_tls"
  }
}
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "aws_key" {
  key_name   = "web001"
  public_key = tls_private_key.tls.public_key_openssh
}

# Save the generated SSH key to a local file with restricted permissions
resource "local_file" "ssh_key" {
  filename        = "${aws_key_pair.aws_key.key_name}.pem"
  content         = tls_private_key.tls.private_key_pem
  file_permission = "0400"
}
resource "aws_instance" "web001" { 
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnet_1a.id
  vpc_security_group_ids = [ aws_security_group.project.id ]
  key_name               = aws_key_pair.aws_key.key_name
  tags = {
    Name = "Web001"
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${aws_key_pair.aws_key.key_name}.pem")  # Updated to use the generated key
    host        = self.public_ip
  }
  user_data = var.user_data_script
}
