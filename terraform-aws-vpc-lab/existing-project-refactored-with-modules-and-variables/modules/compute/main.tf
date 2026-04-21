data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-ebs"]
  }

  owners = ["137112412989"]
}

resource "aws_security_group" "private_ec2_sg" {
  name        = "private-ec2-sg"
  description = "Security group for private EC2 instance"
  vpc_id      = var.vpc_cidr

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-ec2-sg"
  }
}




resource "aws_instance" "private_ec2" {
    ami = data.aws_ami.linux.id
    instance_type = var.vm_type
    subnet_id = var.private_subnet_cidr
    security_groups = [aws_security_group.private_ec2_sg.id]
    associate_public_ip_address = false
    tags = {
        Name = "private-ec2-instance"   
  
}
}