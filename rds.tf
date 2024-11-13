resource "aws_db_subnet_group" "database-1" {
  name       = "database-1"
  subnet_ids = [aws_subnet.subnet-db-a.id, aws_subnet.subnet-db-b.id, aws_subnet.subnet-db-c.id]
}
resource "aws_security_group" "database-sec"{
  name        = "database-sec"
  description = "Allow MySQL inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.ada_vpc.id

  tags = {
    Name = "database-sec"
  }
}
resource "aws_security_group_rule" "database-sec-rule" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.database-sec.id
  cidr_blocks       = [aws_vpc.ada_vpc.cidr_block]
}
resource "aws_rds_cluster" "database-1" {
  cluster_identifier        = "database-1"
  availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]
  db_subnet_group_name      = aws_db_subnet_group.database-1.name
  engine                    = "mysql"
  engine_version            = "8.0.39"
  db_cluster_instance_class = "db.m5d.large"
  storage_type              = "io2"
  allocated_storage         = var.allocated_storage
  iops                      = var.iops
  master_username           = "admin"
  master_password           = var.master_password
}

variable "master_password" {
  description = "Master password for the RDS"
  type        = string
  default     = "admin1234"
}