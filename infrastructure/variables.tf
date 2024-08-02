variable "region" {
    description = "AWS Region"
    type = string
    default = "eu-north-1"
}

variable "project_name" {
    description = "Project name tag"
    type = string
    default = "web3"
}

variable "vpc_name" {
    description = "VPC Name"
    type = string
    default = "Jumphost-VPC"
}

variable "subnet_name" {
    description = "Subnet name"
    type = string
    default = "Jumphost-Subnet"
}

variable "igw_name" {
    description = "Internet gateway name"
    type = string
    default = "Jumphost-IGW"
}

variable "rt_name" {
    description = "Route table name"
    type = string
    default = "Jumphost-RT"
}

variable "sg_name" {
    description = "Security group name"
    type = string
    default = "Jumphost-SG"
}

variable "jumphost_iam_role" {
    description = "Jumphost IAM role name"
    type = string
    default = "jumphost-iam-role"
}

variable "jumphost_instance_profile" {
    description = "Jumphost instance profile name"
    type = string
    default = "jumphost-iam-instance-profile"
}

variable "instance_name" {
    description = "Jumphost instance name"
    type = string
    default = "Jumphost"
}

variable "instance_type" {
    description = "Jumphost instance type"
    type = string
    default = "t3.large"
}

variable "instance_ami_id" {
    description = "Jumphost instance AMI ID"
    type = string
    default = "ami-07c8c1b18ca66bb07"
}
  
variable "key_name" {
    description = "EC2 Keypair"
    type = string
    default = "devopskey"
}

variable "eks_cluster_name" {
    description = "EKS Cluster name"
    type = string
    default = "web3-cluster"
}

variable "eks_node_group_name" {
    description = "EKS Node group name"
    type = string
    default = "web3-workers"
}