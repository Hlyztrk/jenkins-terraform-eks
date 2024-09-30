# Create a VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main-vpc"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.azs.names
  public_subnets = var.public_subnets
  map_public_ip_on_launch = true
  enable_dns_hostnames = true

  tags = {
    Name        = "main-vpc"
  }

  public_subnet_tags = {
    Name = "main-subnets"
  }

  public_route_table_tags = {
    Name = "main-rt"
  }
}

# Create Security Group
module "main_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "main-sg"
  description = "Security group for main vpc"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name = "main-sg"
  }
}

# Create EC2 Instance
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-server"

  instance_type               = var.instance_type
  key_name                    = "main-key"
  monitoring                  = true
  vpc_security_group_ids      = [module.main_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = "true"
  user_data                   = file("user_data.sh")
  availability_zone = data.aws_availability_zones.azs.names[0]

  tags = {
    Name        = "jenkins-server"
    Terraform   = "true"
    Environment = "dev"
  }
}