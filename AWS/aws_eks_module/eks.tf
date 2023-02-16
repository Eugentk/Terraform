#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# eks.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.23.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.21"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  tags = {
    Environment = "${var.main_tags["Environment"]}"
  }
  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    disk_size              = 100
    instance_types         = ["t3a.xlarge"]
    vpc_security_group_ids = [aws_security_group.worker_group.id]
  }
  eks_managed_node_groups = {
    api-eks-node = {
      min_size     = 2
      max_size     = 2
      desired_size = 2
      key_name     = var.key_pair_name


      instance_types = ["t3a.xlarge"]
      capacity_type  = "ON_DEMAND"
      labels = {
        Environment = "Stage"
      }
    }
  }

}
resource "aws_key_pair" "Ec2" {
  key_name   = var.key_pair_name
  public_key = file(var.public_key_path)
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
