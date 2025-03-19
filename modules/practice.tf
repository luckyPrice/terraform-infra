provider "aws" {
  region = "ap-northeast-2" # 원하는 리전으로 변경
}

# VPC 생성
resource "aws_vpc" "terraform_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "terraformVpc"
  }
}

# 인터넷 게이트웨이
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-igw"
  }
}

# 퍼블릭 서브넷
resource "aws_subnet" "terraform_subnet_public_ingress_1a" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone        = "ap-northeast-2a"

  tags = {
    Name = "terraform-subnet-public-ingress-1a",
    Type = "Public"
  }
}

resource "aws_subnet" "terraform_subnet_public_ingress_1c" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone        = "ap-northeast-2c"

  tags = {
    Name = "terraform-subnet-public-ingress-1c",
    Type = "Public"
  }
}

# 프라이빗 서브넷
resource "aws_subnet" "terraform_subnet_private_ingress_1a" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true
  availability_zone        = "ap-northeast-2a"

  tags = {
    Name = "terraform-subnet-private-ingress-1a",
    Type = "Private"
  }
}

resource "aws_subnet" "terraform_subnet_private_ingress_1c" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = true
  availability_zone        = "ap-northeast-2c"

  tags = {
    Name = "terraform-subnet-private-ingress-1c",
    Type = "Private"
  }
}







# 라우트 테이블
resource "aws_route_table" "terraform_route_ingress" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-route-ingress"
  }
}


resource "aws_route_table" "terraform_route_private" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-route-ingress"
  }
}


# 인터넷 액세스 라우트 추가
resource "aws_route" "terraform_route_ingress_default" {
  route_table_id         = aws_route_table.terraform_route_ingress.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.terraform_igw.id
}

resource "aws_route" "terraform_route_private_default" {
  route_table_id         = aws_route_table.terraform_route_private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.terraform_igw.id
}







# 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "terraform_route_ingress_association_1a" {
  subnet_id      = aws_subnet.terraform_subnet_public_ingress_1a.id
  route_table_id = aws_route_table.terraform_route_ingress.id
}

resource "aws_route_table_association" "terraform_route_ingress_association_1c" {
  subnet_id      = aws_subnet.terraform_subnet_public_ingress_1c.id
  route_table_id = aws_route_table.terraform_route_ingress.id
}



# 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "terraform_route_private_association_1a" {
  subnet_id      = aws_subnet.terraform_subnet_private_ingress_1a.id
  route_table_id = aws_route_table.terraform_route_private.id
}

resource "aws_route_table_association" "terraform_route_private_association_1c" {
  subnet_id      = aws_subnet.terraform_subnet_private_ingress_1c.id
  route_table_id = aws_route_table.terraform_route_private.id
}



# 보안 그룹 - 인터넷 트래픽 허용(ingress)
resource "aws_security_group" "terraform_sg_ingress" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-sg-ingress"
  }
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port        = 80
  to_port          = 80
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_sg_ingress.id
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_sg_ingress.id
}



# 보안 그룹 - 인터넷 트래픽 허용(public)
resource "aws_security_group" "terraform_sg_private" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-sg-pirvate"
  }
}


resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_sg_pirvate.id
}