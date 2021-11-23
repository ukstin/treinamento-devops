provider "aws" {
    region = "sa-east-1"
}

#terraform import aws_vpc.vpc_uk vpc-0b7bc0aae8788da62
# vpc-id = vpc-0b7bc0aae8788da62
resource "aws_vpc" "vpc_desafio" {
    cidr_block = "172.18.0.0/16"
    tags = {
        Name = "vpc_desafio"
    }
}

# terraform import aws_internet_gateway.igw igw-<id>
# igw ig = igw-00383a5bb2468a105
resource "aws_internet_gateway" "igw_desafio" {
    vpc_id = aws_vpc.vpc_desafio.id
    tags = {
        Name = "internet-gateway-desafio"
    }
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
    vpc_id = aws_vpc.vpc_desafio.id
    cidr_block = "172.20.0.0/16"
}

resource "aws_subnet" "subnet_desafio_azA_public" {
  vpc_id            = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block        = "172.20.1.0/24"
  availability_zone = "sa-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_desafio_azA_public"
  }
}

resource "aws_subnet" "subnet_desafio_azB_public" {
  vpc_id            = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block        = "172.20.2.0/24"
  availability_zone = "sa-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_desafio_azB_public"
  }
}

resource "aws_subnet" "subnet_desafio_azC_public" {
  vpc_id            = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block        = "172.20.3.0/24"
  availability_zone = "sa-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_desafio_azC_public"
  }
}

resource "aws_subnet" "subnet_desafio_azA_private" {
  vpc_id            = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block        = "172.20.4.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "subnet_desafio_azA_private"
  }
}

resource "aws_subnet" "subnet_desafio_azB_private" {
  vpc_id            = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block        = "172.20.5.0/24"
  availability_zone = "sa-east-1b"

  tags = {
    Name = "subnet_desafio_azB_private"
  }
}

resource "aws_subnet" "subnet_desafio_azC_private" {
  vpc_id            = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block        = "172.20.6.0/24"
  availability_zone = "sa-east-1c"

  tags = {
    Name = "subnet_desafio_azC_private"
  }
}

resource "aws_route_table" "rt_desafio_private" {
  vpc_id = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  route = []
  tags = {
    Name = "route_table_desafio_private"
  }
}

resource "aws_route_table" "rt_desafio_public" {
  vpc_id = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  route = [
      {
        carrier_gateway_id         = ""
        cidr_block                 = "0.0.0.0/0"
        destination_prefix_list_id = ""
        egress_only_gateway_id     = ""
        gateway_id                 = aws_internet_gateway.igw_desafio.id
        instance_id                = ""
       ipv6_cidr_block            = ""
        local_gateway_id           = ""
        nat_gateway_id             = ""
        network_interface_id       = ""
        transit_gateway_id         = ""
        vpc_endpoint_id            = ""
        vpc_peering_connection_id  = ""
      }
  ]

  tags = {
    Name = "route_table_desafio_public"
  }
}

resource "aws_route_table_association" "subnet1_public" {
  subnet_id      = aws_subnet.subnet_desafio_azA_public.id
  route_table_id = aws_route_table.rt_desafio_public.id
}

resource "aws_route_table_association" "subnet2_public" {
    subnet_id      = aws_subnet.subnet_desafio_azB_public.id
    route_table_id = aws_route_table.rt_desafio_public.id
}

resource "aws_route_table_association" "subnet3_public" {
    subnet_id      = aws_subnet.subnet_desafio_azC_public.id
    route_table_id = aws_route_table.rt_desafio_public.id
}

resource "aws_route_table_association" "subnet4_private" {
  subnet_id      = aws_subnet.subnet_desafio_azA_private.id
  route_table_id = aws_route_table.rt_desafio_private.id
}

resource "aws_route_table_association" "subnet5_private" {
    subnet_id      = aws_subnet.subnet_desafio_azB_private.id
    route_table_id = aws_route_table.rt_desafio_private.id
}

resource "aws_route_table_association" "subnet6_private" {
    subnet_id      = aws_subnet.subnet_desafio_azC_private.id
    route_table_id = aws_route_table.rt_desafio_private.id
}

// output "subnet_output" {
//   value = [
//     aws_instance.web.private_ip,
//     "ssh -i ~/Desktop/devops/treinamentoItau ubuntu@${aws_instance.web.private_dns}"
//   ]
//}