module "dashboard_ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.3.0"

  name                        = var.dashboard_ec2_name
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = module.dashboard_counting_app.public_subnets[0]
  vpc_security_group_ids      = [module.dashboard_sg.security_group_id]
  key_name                    = aws_key_pair.dashboard_counting_app.key_name
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/scripts/dashboard-service.sh", {
    counting_private_ip = module.counting_ec2-instance.private_ip
  })

  tags = {
    Name = var.dashboard_ec2_name
  }

}

module "counting_ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.3.0"

  name                        = var.counting_ec2_name
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = module.dashboard_counting_app.private_subnets[0]
  vpc_security_group_ids      = [module.counting_sg.security_group_id]
  key_name                    = aws_key_pair.dashboard_counting_app.key_name
  associate_public_ip_address = false

  user_data = file("${path.module}/scripts/counting-service.sh")

  tags = {
    Name = var.counting_ec2_name
  }

}