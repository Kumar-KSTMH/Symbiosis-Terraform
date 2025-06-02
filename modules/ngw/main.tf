# allocate elastic ip. this eip will be used for the nat-gateway in the web subnet 1a
resource "aws_eip" "eip_nat_1a" {
 domain   = "vpc"

  tags   = {
    Name = "eip-nat-a"
  }
}

# allocate elastic ip. this eip will be used for the nat-gateway in the web subnet 1b
resource "aws_eip" "eip_nat_1b" {
  domain   = "vpc"

  tags   = {
    Name = "eip-nat-b"
  }
}

# create nat gateway in public subnet web-subnet-1a

resource "aws_nat_gateway" "nat_web_subnet_1a" {
  allocation_id = aws_eip.eip_nat_1a.id
  subnet_id     = var.web_subnet_1a_id

  tags   = {
    Name = "ngw-web-subnet-1a"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [var.igw_id]
}

# create nat gateway in web subnet 1b

resource "aws_nat_gateway" "nat_web_subnet_1b" {
  allocation_id = aws_eip.eip_nat_1b.id
  subnet_id     = var.web_subnet_1b_id

  tags   = {
    Name = "ngw-web-subnet-1b"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  # on the internet gateway for the vpc.
  depends_on = [var.igw_id]
}

