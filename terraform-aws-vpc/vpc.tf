resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = merge(
    var.vpc_tags,
    {
        Name = local.resource_name
    }
  )
}


# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = var.igw_tags
}

# public subnet
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
      Name = "${local.resource_name}-public-${local.az_names[count.index]}"
    }
  )
}
# private subnet
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]

  tags = merge(
    var.common_tags,
    var.private_subnet_tags,
    {
      Name = "${local.resource_name}-private-${local.az_names[count.index]}"
    }
  )
}
# database subnet
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]

  tags = merge(
    var.common_tags,
    var.database_subnet_tags,
    {
      Name = "${local.resource_name}-database-${local.az_names[count.index]}"
    }
  )
}

# database subnet group
resource "aws_db_subnet_group" "default" {
  name       = "db-subnet-group"
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    var.common_tags,
    var.db_subnet_group_tags,
    {
      Name = "${local.resource_name}-db-subnet-group"
    }
  )
}

#elastic IP for NAT gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${local.resource_name}-nat-eip"
  }
}

#NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    var.nat_gateway_tags,
    {
      Name = "${local.resource_name}-nat-gateway"
    }
  )
  depends_on = [aws_internet_gateway.igw]
}

# route table for public subnet
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    
    tags = merge(
        var.common_tags,
        var.public_route_table_tags,
        {
        Name = "${local.resource_name}-public-rt"
        }
    )
    }
# route table for private subnet
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    
    tags = merge(
        var.common_tags,
        var.private_route_table_tags,
        {
        Name = "${local.resource_name}-private-rt"
        }
    )
    }
# route table for database subnet
resource "aws_route_table" "database" {
    vpc_id = aws_vpc.main.id
    
    tags = merge(
        var.common_tags,
        var.database_route_table_tags,
        {
        Name = "${local.resource_name}-database-rt"
        }
    )
    }

# route for public route table
resource "aws_route" "public" {
    route_table_id         = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.igw.id
}

# route for private route table
resource "aws_route" "private" {
    route_table_id         = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.nat.id
}

# route for database route table
resource "aws_route" "database" {
    route_table_id         = aws_route_table.database.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.nat.id
}

# associating public subnet with public route table
resource "aws_route_table_association" "public" {
    count          = length(var.public_subnet_cidrs)
    subnet_id      = element(aws_subnet.public.*.id, count.index)
    route_table_id = aws_route_table.public.id
}

# associating private subnet with private route table
resource "aws_route_table_association" "private" {
    count          = length(var.private_subnet_cidrs)
    subnet_id      = element(aws_subnet.private.*.id, count.index)
    route_table_id = aws_route_table.private.id
}

# associating database subnet with database route table
resource "aws_route_table_association" "database" {
    count          = length(var.database_subnet_cidrs)
    # subnet_id      = aws_subnet.database[count.index].id
    subnet_id      = element(aws_subnet.database.*.id, count.index)
    route_table_id = aws_route_table.database.id
}