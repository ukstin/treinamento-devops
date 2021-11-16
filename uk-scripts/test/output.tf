// output "vpc_uk_output" {
//  = concat(aws_vpc.vpc_uk.*.cidr_block, [""])[0]
//   description = "List CIDR of the VPC."
// }
// output "vpc_secondary_cidr_blocks" {
//   description = "List of secondary CIDR blocks of the VPC"
//   value       = concat(aws_vpc_ipv4_cidr_block_association.secondary_cidr.*.cidr_block,[""])[0]
// }


output "instance_ip_addr" {
  value = [
    aws_instance.web_uk.public_ip,
    aws_instance.web_uk.private_ip,
    "ssh -i privatekey_mysql_uk.pem ubuntu@${aws_instance.web_uk.public_dns}"
  ]
}