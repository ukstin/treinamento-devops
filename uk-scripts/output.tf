output "vpc_uk_output" {
  value = [aws_vpc.vpc_uk.vpc_id],
  [aws_vpc.vpc_uk.tags]
  description = "Mostra os IPs publicos e privados da maquina criada."
}