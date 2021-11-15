output "vpc_uk_output" {
  value = concat(aws_vpc.this.*.cidr_block, [""])[0]
  description = "Mostra os IPs publicos e privados da maquina criada."
}