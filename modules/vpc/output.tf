output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC ID"
}

output "web_subnet_1a_id" {
  value = aws_subnet.web_subnet_1a.id
}
output "web_subnet_1b_id" {
  value = aws_subnet.web_subnet_1b.id
}
output "app_subnet_1a_id" {
  value = aws_subnet.app_subnet_1a.id
}

output "app_subnet_1b_id" {
  value = aws_subnet.app_subnet_1b.id
}

output "db_subnets" {
  value       = [for s in aws_subnet.db : s.id]
  description = "List of DB Subnet IDs"
}

output "igw_id" {
  value       = aws_internet_gateway.igw.id
  description = "Internet Gateway ID"
}