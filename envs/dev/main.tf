module "role" {
  source      = "../../modules/iam"
  environment = var.environment
}

module "cluster" {
  source             = "../../modules/ecs_cluster"
  cluster_name       = var.cluster_name
  environment        = var.environment
  capacity_providers = var.capacity_providers
}

module "network" {
  source             = "../../modules/network"
  vpc_name           = var.vpc_name
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnets     = var.public_subnet_cidr_blocks
  private_subnets    = var.private_subnet_cidr_blocks
  availability_zones = var.azs
  environment        = var.environment

}

module "security" {
  source      = "../../modules/security"
  environment = var.environment
  vpc_id      = module.network.vpc_id

}

module "load_balancer" {
  source             = "../../modules/load_balancer"
  vpc_id             = module.network.vpc_id
  private_subnets_id = module.network.private_subnet_ids
  public_subnets_id  = module.network.public_subnet_ids
  app_sg_id          = module.security.app_sg
}

module "cloudmap" {
  source         = "../../modules/cloudmap"
  environment    = var.environment
  vpc_id         = module.network.vpc_id
  namespace_name = var.namespace_name

}

module "ecs_vote" {
  source                = "../../modules/ecs_vote"
  environment           = var.environment
  private_subnet_ids    = module.network.private_subnet_ids
  cluster_id            = module.cluster.cluster_id
  app_sg                = module.security.app_sg
  target_group_arn_vote = module.load_balancer.target_group_arn_vote
  vote_image            = var.vote_image
  role_arn              = module.role.execution_role_arn
  aws_region            = var.aws_region
  depends_on            = [module.load_balancer.aws_listener_http, module.load_balancer.target_group_arn_vote]
}

module "ecs_result" {
  source                  = "../../modules/ecs_result"
  environment             = var.environment
  private_subnets_id      = module.network.private_subnet_ids
  app_sg                  = module.security.app_sg
  cluster_id              = module.cluster.cluster_id
  target_group_arn_result = module.load_balancer.target_group_arn_result
  result_image            = var.result_image
  role_arn                = module.role.execution_role_arn
  aws_region              = var.aws_region
  depends_on              = [module.load_balancer.aws_listener_http, module.load_balancer.target_group_arn_result]
}

module "ecs_worker" {
  source             = "../../modules/ecs_worker"
  environment        = var.environment
  private_subnet_ids = module.network.private_subnet_ids
  app_sg             = module.security.app_sg
  cluster_id         = module.cluster.cluster_id
  worker_image       = var.worker_image
  role_arn           = module.role.execution_role_arn
  aws_region         = var.aws_region
}

module "redis" {
  source             = "../../modules/ecs_redis"
  environment        = var.environment
  subnet_ids         = module.network.private_subnet_ids
  security_group_id  = module.security.databases_sg
  redis_image        = var.redis_image
  cluster_arn        = module.cluster.cluster_id
  execution_role_arn = module.role.execution_role_arn
  task_role_arn      = module.role.execution_role_arn
  redis_service_arn  = module.cloudmap.redis_service_id
  region             = var.aws_region
}

module "postgres" {
  source             = "../../modules/ecs_postgres"
  environment        = var.environment
  subnet_ids         = module.network.private_subnet_ids
  security_group_id  = module.security.databases_sg
  postgres_image     = var.postgres_image
  cluster_arn        = module.cluster.cluster_id
  execution_role_arn = module.role.execution_role_arn
  task_role_arn      = module.role.execution_role_arn
  db_service_arn     = module.cloudmap.db_service_id
  region             = var.aws_region
}
