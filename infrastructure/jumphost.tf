resource "aws_instance" "ec2" {
  ami           = var.instance_ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public-subnet[0].id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.security-group.id]
  iam_instance_profile = aws_iam_instance_profile.instance-profile.name
  root_block_device {
    volume_size = 30
  }

  user_data = templatefile("./tools.sh", {})

  tags = {
    Name = var.instance_name
    Project = var.project_name
  }

  depends_on = [aws_eks_cluster.cointracker_cluster, aws_eks_node_group.cointracker_node_group]
}