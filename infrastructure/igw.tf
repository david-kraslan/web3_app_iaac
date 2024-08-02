resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

      tags = {
    Name = var.igw_name
    Project = var.project_name
  }
}