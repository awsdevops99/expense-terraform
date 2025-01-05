resource "aws_db_parameter_group" "main" {
  name   = "${var.env}-mysql-rds"
  family = "mysql5.6"
tags   = merge(var.tags, { Name = "${var.env}-mysql-rds" })
}
resource "aws_db_subnet_group" "main" {
  name       =  "${var.env}-mysql-rds"
  subnet_ids = var.subnets

  tags   = merge(var.tags, { Name = "${var.env}-mysql-rds" })
  }

  resource "aws_security_group" "main" {
  name        = "${var.env}-mysql-rds"
  description = "${var.env}-mysql-rds"
  vpc_id      = var.vpc_id

  ingress = {
      description = "MYSQL"
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks= var.sg_cidr 
  }

 egress = {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.tags, {Name = "${env.var}-mysql-rds"})
  }


resource "aws_db_instance" "default" {
  allocated_storage    = var.rds_allocated_storage
  db_name              = "mydb"
  engine               = var.rds_engine
  engine_version       = var.rds_engine_version
  instance_class       = var.rds_instance_class
  username             = data.aws_ssm_parameter.username.value
  password             = data.aws_ssm_parameter.password.value
  parameter_group_name = aws_db_parameter_group.main.name
  identifier = "${env.var}-mysql-rds"
  skip_final_snapshot  = true
  multi_az = true
  storage_type   =   "gp3"
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids =[aws_db_security_group.main.id]
}




