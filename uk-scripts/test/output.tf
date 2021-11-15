output "vpc_uk_output" {
  value = [
    for key, item in aws_vpc.vpc_uk:
      "${item.id}"
  ]
  #value = concat(aws_vpc.vpc_uk.*.cidr_block, [""])[0]
  description = "List CIDR of the VPC."
}
output "vpc_secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks of the VPC"
  value       = concat(aws_vpc_ipv4_cidr_block_association.secondary_cidr.*.cidr_block,[""])[0]
}

// output "instance_ip_addr" {
//   value = [
//     for key, item in aws_instance.web:
//       "${item.private_ip}, ${item.public_ip}" 
//   ]
//   description = "Mostra os IPs publicos e privados da maquina criada."
// }