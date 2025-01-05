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

module "vpc" {
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
    sg_cidr = var.web_subnets
    subnets = module.vpc.app_subnets
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
    sg_cidr = var.web_subnets
    subnets = module.vpc.app_subnets
    
}




