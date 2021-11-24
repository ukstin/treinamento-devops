provider "aws" {
    region = "sa-east-1"
}

# resource "aws_eip" "nat1" {
#   # EIP may require IGW to exist prior to association. 
#   # Use depends_on to set an explicit dependency on the IGW.
#   depends_on = aws_internet_gateway.main
# }

resource "aws_nat_gateway" "gw1" {
  # The Allocation ID of the Elastic IP address for the gateway.
  allocation_id = "eipalloc-ec0777ed" 
  #aws_eip.nat1.id
  # The Subnet ID of the subnet in which to place the gateway.
  subnet_id = "subnet-08fb0f3d30afab93d" 
  #aws_subnet.public_1.id
  # A map of tags to assign to the resource.
  tags = {
    Name = "NAT Desafio"
  }
}





// resource "aws_eip" "nat_gateway" {
//   vpc = true
// }

// resource "aws_nat_gateway" "nat_gateway" {
//   allocation_id = aws_eip.nat_gateway.id
//   subnet_id = aws_subnet.nat_gateway.id
//   tags = {
//     "Name" = "desafio-nat-gateway"
//   }
// }

// output "nat_gateway_ip" {
//   value = aws_eip.nat_gateway.public_ip
// }

resource "aws_route_table" "route_table_desafio_private" {
  vpc_id = "vpc-0b7bc0aae8788da62"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw1.id
  }
  tags = {
    Name = "route_table_desafio_private"
  }
}

resource "aws_route_table_association" "route_table_association_nat_gateway" {
  subnet_id = "subnet-02990c5c850e1fbc5"
  route_table_id = aws_route_table.route_table_desafio_private.id
}