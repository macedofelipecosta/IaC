data "aws_iam_role" "labrole" {
  name = "LabRole" # Asegurate de usar el nombre exacto del rol
}


data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

module "lambda_backup" {
  source          = "../../modules/lambda"
  environment     = var.environment
  lambda_zip_file = data.archive_file.zip.output_path
  role_arn        = data.aws_iam_role.labrole.arn
}

module "cloudwatch" {
  source           = "../../modules/cloudwatch"
  dashboard_name   = "voting-app-dashboard-${var.environment}"
  ecs_cluster_name = module.cluster.cluster_name
  rds_instance_id  = module.rds_postgres.postgres_instance_id
  redis_cluster_id = module.elasticache.redis_cluster_id
  aws_region       = var.aws_region
  alb_result_name  = module.load_balancer.alb_result_arn_suffix
  alb_vote_name    = module.load_balancer.alb_vote_arn_suffix
  depends_on = [module.ecs_result, module.ecs_vote, module.ecs_worker, module.elasticache, module.rds_postgres, module.load_balancer]
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
  depends_on            = [module.load_balancer.target_group_arn_result, module.load_balancer.target_group_arn_vote]
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
  depends_on = [module.ecs_worker.ecs_task_def_worker_id]
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
  rds_sg             = module.security.postgres_sg
  redis_sg           = module.security.redis_sg
  depends_on         = [module.rds_postgres.postgres_endpoint, module.elasticache.redis_endpoint, module.rds_postgres.postgres_db_name]

}

module "elasticache" {
  source             = "../../modules/elasticache_redis"
  environment        = var.environment
  private_subnet_ids = module.network.private_subnet_ids
  redis_sg_id        = module.security.redis_sg
  app_sg_id          = module.security.app_sg
}

module "rds_postgres" {
  source             = "../../modules/rds_postgres"
  environment        = var.environment
  private_subnet_ids = module.network.private_subnet_ids
  postgres_sg_id     = module.security.postgres_sg
  app_sg_id          = module.security.app_sg
  db_name            = "votedb"
}

