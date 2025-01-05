env ="dev"
tags = {
    company_name = "om"
    bu_unit = "finance"
    project_name = "expense"
}

vpc_cidr_block = "10.10.0.0/16"
public_subnets = ["10.10.0.0/24", "10.10.1.0/24"]
web_subnets    = ["10.10.2.0/24", "10.10.3.0/24"]
app_subnets    = ["10.10.4.0/24", "10.10.5.0/24"]
db_subnets     = ["10.10.6.0/24", "10.10.7.0/24"]


default_vpc_id = "vpc-0f42513d439728731"
default_route_table_id = "rtb-0eb2513425872b286"
account_id = "831926604528"
default_vpc_cidr = "172.31.0.0/16"
azs = ["us-east-1a", "us-east-1b"]

allocated_storage = 20
engine = "mysql"
engine_version = "8.0"
instance_class = "db.t3.micro"


backend = {

        app_port = 8080
        instance_count = 1
        instance_type = "t3.small"
}

frontend = {
    app_port = 80
    instance_count = 1
    instance_type = "t3.small"
}




