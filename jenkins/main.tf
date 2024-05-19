module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.az.names
  public_subnets = var.public_subnets

  map_public_ip_on_launch = true
  enable_dns_hostnames    = true

  tags = {
    Name        = "jenkins-vpc"
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "jenkins-subnet"
  }
}

module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-sg"
  description = "SG for VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Jenkins Port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port  = 0
      to_port    = 0
      protocol   = -1
      cidr_block = "0.0.0.0/0"
    },
  ]

  tags = {
    Name = "jenkins-sg"
  }
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "Jenkins-EC2"
  //  ami                         = "ami-0f58b397bc5c1f2e8"
  instance_type               = var.instance_type
  key_name                    = "LinuxKey"
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  availability_zone           = data.aws_availability_zones.az.names[0]
  user_data                   = file("install.sh")

  tags = {
    Name        = "Jenkins-EC2"
    Terraform   = "true"
    Environment = "dev"
  }
}
