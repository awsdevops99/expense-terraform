module "vpc" {
    source = "./modules/vpc"

    env = var.env
    tags = var.tags
    vpc_cidr_block =  var.vpc_cidr_block
    public_subnets = var.public_subnets
    web_subnets    =     var.web_subnets
    app_subnets = var.app_subnets
    db_subnets = var.db_subnets
    default_route_table_id = var.default_route_table_id
    default_vpc_cidr = var.default_vpc_cidr
    default_vpc_id = var.default_vpc_id
    account_id = var.account_id
    azs= var.azs


}

module "rds" {
    source = "./modules/rds"

    subnets = module.vpc.db_subnets
    env = var.env
    tags = var.tags
    rds_allocated_storage = var.rds_allocated_storage
    rds_engine = var.rds_engine
    rds_engine_version = var.rds_engine_version
    rds_instance_class = var.rds_instance_class
    sg_cidr = var.app_subnets
    vpc_id = module.vpc.vpc_id

    

}

module "app" {
    source = "./modules/app"

    env = var.env
    tags = var.tags
    vpc_id = module.vpc.vpc_id
    app_port = var.backend["app_port"]
    component = "backend"
    instance_count = var.backend["instance_count"]
    instance_type = var.backend["instance_type"]
    sg_cidr = var.app_subnets
    subnets = module.vpc.app_subnets
    bastion_cidrs = var.bastion_cidrs
}

module "frontend" {
    source = "./modules/app"

    env = var.env
    tags = var.tags
    vpc_id = module.vpc.vpc_id
    app_port = var.frontend["app_port"]
    component = "frontend"
    instance_count = var.frontend["instance_count"]
    instance_type = var.frontend["instance_type"]
    sg_cidr = var.public_subnets
    subnets = module.vpc.app_subnets
    bastion_cidrs = var.bastion_cidrs

}

module "public-alb" {
    source = "./modules/alb"
   
    lb_port = var.public_alb["lb_port"]
    sg_cidr = ["0.0.0.0/0"]
    target_group_arn = module.frontend.target_group_arn
    vpc_id = module.vpc.vpc_id
    tags = var.tags
    env =  var.env
    subnets = module.vpc.public_subnets
    internal = var.public_alb["internal"]
    type = var.public_alb["type"]
    component = var.public_alb["component"]

    }

    module "backend" {
    source = "./modules/alb"

    lb_port = var.backend_alb["alb"]
    sg_cidr = ["0.0.0.0/0"]
    target_group_arn = module.backend.target_group_arn
    vpc_id = module.vpc.vpc_id
    tags = var.tags
    env =  var.env
    subnets = module.vpc.public_subnets
    internal = var.backend_alb["internal"]
    type = var.backend_alb["type"]
    component = var.backend_alb["component"]

    }


 

