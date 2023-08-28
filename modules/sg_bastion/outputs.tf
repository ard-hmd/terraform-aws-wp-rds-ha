# Output: ID of the bastion instance security group
output "sg_bastion_id" {
  description = "The ID of the bastion instance security group"  # Describing the purpose of the output
  value       = aws_security_group.bastion_instance.id  # Extracting the ID of the bastion instance security group
}
