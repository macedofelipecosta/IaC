data "aws_iam_role" "labrole" {
  name = "LabRole"  # Asegurate de usar el nombre exacto del rol
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


module "ecs_vote" {
  source                = "../../modules/ecs_vote"
  environment           = var.environment
  private_subnets_id    = module.network.private_subnet_ids
  cluster_id            = module.cluster.cluster_id
  app_sg                = module.security.app_sg
  target_group_arn_vote = module.load_balancer.target_group_arn_vote
  vote_image            = var.vote_image
  role_arn              = data.aws_iam_role.labrole.arn
  aws_region            = var.aws_region
  redis_endpoint        = module.elasticache.redis_endpoint
  redis_port            = module.elasticache.redis_port
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
  role_arn                = data.aws_iam_role.labrole.arn
  aws_region              = var.aws_region
  postgres_endpoint       = module.rds_postgres.postgres_endpoint
  postgres_db_name        = module.rds_postgres.postgres_db_name
  depends_on              = [module.load_balancer.aws_listener_http, module.load_balancer.target_group_arn_result, module.ecs_worker]
}



module "ecs_worker" {
  source             = "../../modules/ecs_worker"
  environment        = var.environment
  private_subnets_id = module.network.private_subnet_ids
  app_sg             = module.security.app_sg
  cluster_id         = module.cluster.cluster_id
  worker_image       = var.worker_image
  role_arn           = data.aws_iam_role.labrole.arn
  aws_region         = var.aws_region
  postgres_endpoint  = module.rds_postgres.postgres_endpoint
  redis_endpoint     = module.elasticache.redis_endpoint
  postgres_db_name   = module.rds_postgres.postgres_db_name
  postgres_port      = module.rds_postgres.postgres_port
  redis_port         = module.elasticache.redis_port
}

module "elasticache" {
  source             = "../../modules/elasticache_redis"
  environment        = var.environment
  private_subnet_ids = module.network.private_subnet_ids
  redis_sg_id        = module.security.redis_sg
}

module "rds_postgres" {
  source             = "../../modules/rds_postgres"
  environment        = var.environment
  private_subnet_ids = module.network.private_subnet_ids
  postgres_sg_id     = module.security.postgres_sg
}

