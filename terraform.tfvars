vpc_name             = "dashboard-counting-app-vpc"
vpc_cidr             = "192.168.0.0/16"
azs                  = ["ap-southeast-1a"]
enable_dns_hostnames = true

public_subnets = ["192.168.1.0/24"]
public_subnet_tags = {
  "Name" = "dashboard-app"
}

private_subnets = ["192.168.2.0/24"]
private_subnet_tags = {
  "Name" = "counting-app"
}

dashboard_sg_name = "dashboard-app-sg"
ingress_with_cidr_blocks = [
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "2.49.136.161/32"
  },
  {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = "2.49.136.161/32"
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

counting_sg_name   = "counting-app-sg"
dashboard_ec2_name = "dashboard-service"
instance_type      = "t3.micro"
counting_ec2_name  = "counting-service"