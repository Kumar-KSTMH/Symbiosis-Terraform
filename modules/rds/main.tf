
resource "aws_db_subnet_group" "db_subnet" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.db_subnets
  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

resource "aws_db_instance" "db" {
  identifier              = "symbiosis-db-instance"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t3.medium"
  allocated_storage       = 20
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  multi_az                = true
  storage_type            = "gp3"
  storage_encrypted       = false
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 0

  vpc_security_group_ids = [var.db_sg]

  db_subnet_group_name = aws_db_subnet_group.db_subnet.name

  tags = {
    Name    = "${var.project_name}-db"
    Project = var.project_name
  }
}