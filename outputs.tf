output "counting_private_ip" {
  value = module.counting_ec2-instance.private_ip
}

output "dashboard_public_ip" {
  value = module.dashboard_ec2-instance.public_ip
}