output "vpc_id"{
  value=aws_vpc.main.id
}
output "vpc_cidr_block"{
  value=aws_vpc.main.cidr_block
}
output "public_subnet_ids"{
  value=aws_subnet.public_subnet[*].id
}

output "private_subnet_ids"{
  value=aws_subnet.private_subnet[*].id
}

output "aws_natgateway_id"{
  value=aws_nat_gateway.nat_gw.id
}

output "aws_internetgateway_id"{
  value=aws_internet_gateway.igw.id
}

output "aws_eip_id"{
  value=aws_eip.nat_eip.id
}

output "aws_route_table_public_id"{
  value=aws_route_table.public_route_table.id
}
output "aws_route_table_private_id"{
  value=aws_route_table.private_route_table.id
}