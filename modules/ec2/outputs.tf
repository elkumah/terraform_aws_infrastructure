output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.ec2_instance.id
}
output "public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = aws_instance.ec2_instance.public_ip
}
output "private_ip" {
  description = "The private IP address of the EC2 instance."
  value       = aws_instance.ec2_instance.private_ip
}
output "security_group_id" {
  description = "The ID of the security group associated with the EC2 instance."
  value       = aws_security_group.ec2_sg.id
}
output "ami_id" {
  description = "The ID of the AMI used for the EC2 instance."
  value       = data.aws_ami.ubuntu.id
}
output "instance_type" {
  description = "The type of the EC2 instance."
  value       = var.instance_type
}                              