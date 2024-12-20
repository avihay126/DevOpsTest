resource "aws_subnet" "avihay-subnet_a" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_sub_a
  availability_zone = var.zone_a
  map_public_ip_on_launch                        = false

  tags = {
    Name = "avihay-subnet-a"
  }
}

resource "aws_subnet" "avihay-subnet_b" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_sub_b
  availability_zone = var.zone_b
  map_public_ip_on_launch                        = false

  tags = {
    Name = "avihay-subnet-b"
  }
}


resource "aws_route_table" "route_table_private" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_gateway
  }

  tags = {
    Name = "avihay-rt-private"
  }
}


resource "aws_route_table_association" "rt_to_subnet_a" {
  subnet_id      = aws_subnet.avihay-subnet_a.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_route_table_association" "rt_to_subnet_b" {
  subnet_id      = aws_subnet.avihay-subnet_b.id
  route_table_id = aws_route_table.route_table_private.id
}






data "aws_s3_bucket" "my_s3_bucket" {
  bucket = var.s3bucket_name  
}


data "aws_iam_user" "my_user" {
  user_name = var.user_name
}




data "aws_iam_policy_document" "bucket_access_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${data.aws_s3_bucket.my_s3_bucket.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_user.my_user.arn]
    }
  }
}



resource "aws_s3_bucket_policy" "allow_user_access" {
  bucket = data.aws_s3_bucket.my_s3_bucket.id
  policy = data.aws_iam_policy_document.bucket_access_policy.json
}


module "eks" {

  source          = "terraform-aws-modules/eks/aws"
  version         = "20.24.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  cluster_endpoint_public_access  = true

  enable_cluster_creator_admin_permissions = true

  vpc_id = var.vpc_id
  subnet_ids = [aws_subnet.avihay-subnet_a.id, 
                aws_subnet.avihay-subnet_b.id
              ]
  
  cluster_addons = {
    coredns                = {
      addon_version = "v1.11.1-eksbuild.4"
    }
    aws-ebs-csi-driver         = {
      addon_version = "v1.35.0-eksbuild.1"
    }
  }
  eks_managed_node_group_defaults = {
    instance_types = [var.instance_type]
  }

  eks_managed_node_groups = {
    "avihay-nodegroup" = {
      min_size     = 1
      max_size     = 3
      desired_size = 1
      instance_types = [var.instance_type] 
    }
  }

  access_entries = {
    ester_access = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::730335218716:user/esterh"

      policy_associations = {
        view_policy = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
  }
  
}

resource "aws_route53_record" "avihay_record" {
  zone_id = var.domain_host_id
  name    = var.dns_record
  type    = "CNAME"
  ttl     = 60
  records = [var.lb_dns]
}

