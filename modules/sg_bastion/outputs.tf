output "sg_bastion_id" {
  description = "The ID of the bastion instance security group"
  value       = aws_security_group.bastion_instance.id
}
