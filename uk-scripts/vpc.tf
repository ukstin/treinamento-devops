resource "aws_vpc" "my_vpc" {
  cidr_block = "192.168.16.0/20"
  enable_dns_hostnames = true

  tags = {
    Name = "vcp_uk_terraform"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "192.168.16.0/24"
  availability_zone = "us-east-1a"
  #map_public_ip_on_launch = true

  tags = {
    Name = "subnet_uk_azA_terraform_public"
  }
}

resource "aws_subnet" "my_subnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "192.168.17.0/24"
  availability_zone = "us-east-1b"
  #map_public_ip_on_launch = true

  tags = {
    Name = "subnet_uk_azB_terraform_public"
  }
}

resource "aws_subnet" "my_subnet3" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "192.168.18.0/24"
  availability_zone = "us-east-1c"
  #map_public_ip_on_launch = true

  tags = {
    Name = "subnet_uk_azC_terraform_public"
  }
}

resource "aws_subnet" "my_subnet4" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "192.168.19.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet_uk_azB_terraform_private"
  }
}

#resource "aws_internet_gateway" "gw" {
#  vpc_id = aws_vpc.my_vpc.id
#
#  tags = {
#    Name = "internet_gateway_uk_terraform"
#  }
#}

resource "aws_route_table" "rt_terraform_private" {
  vpc_id = aws_vpc.my_vpc.id
  route = []
  tags = {
    Name = "route_table_uk_private"
  }
}

resource "aws_route_table" "rt_terraform" {
  vpc_id = aws_vpc.my_vpc.id
  route = []

#  route = [
#      {
#        carrier_gateway_id         = ""
#        cidr_block                 = "0.0.0.0/0"
#        destination_prefix_list_id = ""
#        egress_only_gateway_id     = ""
#        gateway_id                 = ""
#        instance_id                = ""
#       ipv6_cidr_block            = ""
#        local_gateway_id           = ""
#        nat_gateway_id             = ""
#        network_interface_id       = ""
#        transit_gateway_id         = ""
#        vpc_endpoint_id            = ""
#        vpc_peering_connection_id  = ""
#      }
#  ]

  tags = {
    Name = "route_table_uk_public"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.rt_terraform.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.my_subnet2.id
  route_table_id = aws_route_table.rt_terraform.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.my_subnet3.id
  route_table_id = aws_route_table.rt_terraform.id
}

resource "aws_route_table_association" "d" {
  subnet_id = aws_subnet.my_subnet4.id
  route_table_id = aws_route_table.rt_terraform_private.id
}

# resource "aws_network_interface" "my_subnet" {
#   subnet_id           = aws_subnet.my_subnet.id
#   private_ips         = ["172.17.10.100"] # IP definido para instancia
#   # security_groups = ["${aws_security_group.allow_ssh1.id}"]

#   tags = {
#     Name = "primary_network_interface my_subnet"
#   }
# }