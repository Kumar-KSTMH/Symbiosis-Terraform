# create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# create internet gateway and attach it to vpc

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# use data source to get all avalablility zones in region

data "aws_availability_zones" "available_zones" {}

# create web_subnet_1a

resource "aws_subnet" "web_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.web_subnet_1a_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-web-subnet-1a"
  }
}

# create web_subnet_1b
resource "aws_subnet" "web_subnet_1b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.web_subnet_1b_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-web-subnet-1b"
  }
}

# create route table and add route

resource "aws_route_table" "web_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-rt-web"
  }
}

# associate web subnets to web route table
resource "aws_route_table_association" "web_subnet_1a_route_table_association" {
  subnet_id      = aws_subnet.web_subnet_1a.id
  route_table_id = aws_route_table.web_route_table.id
}

resource "aws_route_table_association" "web_subnet_1b_route_table_association" {
  subnet_id      = aws_subnet.web_subnet_1b.id
  route_table_id = aws_route_table.web_route_table.id
}

# create app_subnet_1a

resource "aws_subnet" "app_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.app_subnet_1a_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-app-subnet-1a"
  }
}

# create app_subnet_1b
resource "aws_subnet" "app_subnet_1b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.app_subnet_1b_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-app-subnet-1b"
  }
}

# create route table and add route

resource "aws_route_table" "app_route_table_1a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.ngw_web_subnet_1a_id
  }

  tags = {
    Name = "${var.project_name}-rt-app-1a"
  }
}

resource "aws_route_table" "app_route_table_1b" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.ngw_web_subnet_1b_id
  }

  tags = {
    Name = "${var.project_name}-rt-app-1b"
  }
}
# associate app subnets to app route table
resource "aws_route_table_association" "app_subnet_1a_route_table_association" {
  subnet_id      = aws_subnet.app_subnet_1a.id
  route_table_id = aws_route_table.app_route_table_1a.id
}

resource "aws_route_table_association" "app_subnet_1b_route_table_association" {
  subnet_id      = aws_subnet.app_subnet_1b.id
  route_table_id = aws_route_table.app_route_table_1b.id
}

# create private DB subnets 


resource "aws_subnet" "db" {
  for_each = zipmap(var.db_subnets_cidr, var.azs)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.key
  availability_zone       = each.value
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-db-subnet-${each.key}"
    Environment = var.environment
  }
}


# DB Tier Route Table

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project_name}-rt-db"
    Environment = var.environment
  }
}

# Associate DB subnets

resource "aws_route_table_association" "db" {
  for_each = aws_subnet.db

  subnet_id      = each.value.id
  route_table_id = aws_route_table.db.id
}