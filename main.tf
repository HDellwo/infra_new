# Configure the AWS provider
provider "aws" {
  region  = "us-east-1"
  profile = "harald-iam-admin"
}

# Call the networking module
module "networking" {
  source              = "./modules/networking"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.0.0/24"
  private_subnet_cidr = "10.0.1.0/24"
  public_az           = "us-east-1a"
  private_az          = "us-east-1b"
}

# Security Group for Public EC2 instance with ICMP, SSH, HTTP, and HTTPS allowed
resource "aws_security_group" "public_sg" {
  vpc_id = module.networking.vpc_id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public EC2 Security Group"
  }
}

# Launch Public EC2 instance in the public subnet
resource "aws_instance" "public_instance" {
  ami                         = "ami-0984f4b9e98be44bf"
  instance_type               = "t2.micro"
  subnet_id                   = module.networking.public_subnet_id
  associate_public_ip_address = true
  security_groups          = [aws_security_group.public_sg.id]  # Use ID of the security group

  tags = {
    Name = "Public EC2 Instance"
  }

  depends_on = [aws_security_group.public_sg]  # Ensure security group is created first
}

# Launch Private EC2 instance in the private subnet
resource "aws_instance" "private_instance" {
  ami               = "ami-0984f4b9e98be44bf"
  instance_type     = "t2.micro"
  subnet_id         = module.networking.private_subnet_id
  security_groups = [aws_security_group.public_sg.id]  # Same security group used here

  tags = {
    Name = "Private EC2 Instance"
  }

  depends_on = [aws_security_group.public_sg]  # Ensure security group is created first
}

# Outputs
output "public_instance_ip" {
  value = aws_instance.public_instance.public_ip
}

output "Greetings" {
  value = "Hello Sharanya!"
}
