resource "aws_security_group" "aws-sg" {
  vpc_id = aws_vpc.upgrad.id
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_key_pair" "ec2-key" {
  key_name   = "upgrad-key-ec2"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCnFQOfW8S6sZ1o7dQ+6YmkM5Gk/d5J3LDm6uQ3RtG7+JgfrJZTv4FiFw9e8kIpgeBYjm+KRivBtxJ3LpHkvkWjJNNzQ4ycFHKZ78k1+GNzrCRJcJ9j4cO/9UJs3nLt1vcZ7dfqFumvJcVVCOFcTo6E3IxKfh5zZazXGjgMDxyqtEOHU8HBaw7sE+zkkniehm99zsvLNI+1VQoasq+QhhKvnk2lvx4qsGznx3yQ1DMUW1bkKl49iRMhMl7MZZEbhv90c8wkBGh4sk4IgS2aW5NMxOMKKUErbC1Py0IBPiiM1RP8PHcR6xuAfZ0Mu+IeFOaLULVs0k4v6QReQoLJzYKzYXIKfb2p2O4j3rSY9pzcnREp4S2bNF79xhdlyx94l5NVrrIeelSwTteUwGlO0B4F7RpkrW4ztj3G1oOz6YMcSdJadL3RFx60+jWffE6dN2W4K5hZvu0BCy4JmkJPUsazN0yg1wr1Uf9fcHKiUkpkcvNkSIfg2jJ4UM0p8d5TrU= ubuntu@ip-172-31-14-159"
}

resource "aws_instance" "my_ec2" {
  ami                         = "ami-0149b2da6ceec4bb0"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.upgrad3.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2-key.key_name
  vpc_security_group_ids      = [aws_security_group.aws-sg.id]
}

output "ec2_public_ip" {
  value = aws_instance.my_ec2.public_ip
}
