resource "aws_subnet" "avihay-subnet_a" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_sub_a

  tags = {
    Name = "avihay-subnet-a"
  }
}

resource "aws_subnet" "avihay-subnet_b" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_sub_b

  tags = {
    Name = "avihay-subnet-b"
  }
}


resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_gateway
  }

  tags = {
    Name = "avihay-rt"
  }
}


resource "aws_route_table_association" "rt_to_subnet_a" {
  subnet_id      = aws_subnet.avihay-subnet_a.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "rt_to_subnet_b" {
  subnet_id      = aws_subnet.avihay-subnet_b.id
  route_table_id = aws_route_table.route_table.id
}






data "aws_s3_bucket" "my_s3_bucket" {
  bucket = "avihay-bucket"  
}


data "aws_iam_user" "my_user" {
  user_name = "avihay-user"
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