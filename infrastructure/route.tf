resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

      tags = {
    Name = var.rt_name
    Project = var.project_name
  }
}

resource "aws_route_table_association" "main" {
  count = length(aws_subnet.public-subnet.*.id)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.rt.id
}