resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_required ? 1 : 0
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = var.peer_owner_id == "" ? data.aws_vpc.default.id : var.peer_owner_id
  vpc_id        = aws_vpc.main.id
  auto_accept  = var.peer_owner_id == "" ? true : false

    tags = merge(
    var.common_tags,
    var.peering_tags,
    {
      Name = "${local.resource_name}-peering-connection"
    }
    )
}

# route to peer VPC from public route table
resource "aws_route" "public-peering" {
    count = var.is_peering_required && var.peer_owner_id == "" ? 1 : 0
    route_table_id         = aws_route_table.public.id
    destination_cidr_block = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

# route to peer VPC from private route table
resource "aws_route" "private-peering" {
    count = var.is_peering_required && var.peer_owner_id == "" ? 1 : 0
    route_table_id         = aws_route_table.private.id
    destination_cidr_block = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

# route to peer VPC from database route table
resource "aws_route" "database-peering" {
    count = var.is_peering_required && var.peer_owner_id == "" ? 1 : 0
    route_table_id         = aws_route_table.database.id
    destination_cidr_block = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

# route to this VPC from peer VPC
resource "aws_route" "default-peering" {
    count = var.is_peering_required && var.peer_owner_id == "" ? 1 : 0
    route_table_id         = data.aws_route_table.main.id
    destination_cidr_block = var.vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}


