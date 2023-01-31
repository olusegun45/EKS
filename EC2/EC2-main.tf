# Resource-7: Creat Security Group for Web Server
resource "aws_security_group" "project-SG" {
  name        = "project-SG"
  description = "Allow All traffic"
  vpc_id      = aws_vpc.Project-1-VPC.id

  ingress    {
      description      = "All traffic"
      from_port         = 0
      to_port           = 65535
      protocol          = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  egress     {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "project-SG"
  }
}

# Resource-8: Creat Ubuntu 18.04
resource "aws_instance" "Dev-VM" {
  ami           = "ami-071c33e7823c066b5"
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.Project-1-Pub-sbn.id
  vpc_security_group_ids = [aws_security_group.project-SG.id]
  iam_instance_profile = "${aws_iam_instance_profile.CSD-instance_profile.name}"

  tags = {
    Name = "Dev-VM"
  }
}

