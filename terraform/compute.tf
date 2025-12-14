# ----------------------------
# Get latest Amazon Linux AMI
# ----------------------------

variable "key_name" {
description = "Existing EC2 key pair name"
}


data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64*"]
  }
}


# ----------------------------
# Get default VPC
# ----------------------------
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "web-sg-laba" {
name = "web-sg-laba"


ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}


ingress {
from_port = 5000
to_port = 5000
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}


egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
  }
}



# ----------------------------
# Create EC2 Instance
# ----------------------------
resource "aws_instance" "demo_ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnets.default.ids[0]
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.web-sg-laba.id] 

  tags = {
    Name = "terraform-demo-ec2"
  }
}
