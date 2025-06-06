module "vpc" {
  source               = "../modules/vpc"
  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  web_subnet_1a_cidr   = var.web_subnet_1a_cidr
  web_subnet_1b_cidr   = var.web_subnet_1b_cidr
  app_subnet_1a_cidr   = var.app_subnet_1a_cidr
  app_subnet_1b_cidr   = var.app_subnet_1b_cidr
  db_subnets_cidr      = var.db_subnets_cidr
  ngw_web_subnet_1a_id = module.ngw.ngw_web_subnet_1a_id
  ngw_web_subnet_1b_id = module.ngw.ngw_web_subnet_1b_id
}

module "ngw" {
  source           = "../modules/ngw"
  vpc_id           = module.vpc.vpc_id
  igw_id           = module.vpc.igw_id
  web_subnet_1a_id = module.vpc.web_subnet_1a_id
  web_subnet_1b_id = module.vpc.web_subnet_1b_id

}

module "sg" {
  source       = "../modules/sg"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  environment  = var.environment
}

# creating RDS instance

module "rds" {
  source          = "../modules/rds"
  vpc_id          = module.vpc.vpc_id
  project_name    = var.project_name
  environment     = var.environment
  db_sg           = module.sg.db_sg
  db_subnets      = module.vpc.db_subnets
  db_username     = var.db_username
  db_password     = var.db_password
  rds_kms_key_arn = module.kms.rds_kms_key_arn
}

module "key" {
  source          = "../modules/key"
  project_name    = var.project_name
  environment     = var.environment
  public_key_path = var.public_key_path
}

module "kms" {
  source = "../modules/kms"
}


module "ssm" {
  source      = "../modules/ssm"
  db_host     = module.rds.db_endpoint
  db_username = var.db_username
  db_password = var.db_password
}

module "iam" {
  source      = "../modules/iam"
  environment = var.environment
}

module "ec2-web" {
  source                    = "../modules/ec2-web"
  web_subnet_1a_id          = module.vpc.web_subnet_1a_id
  web_subnet_1b_id          = module.vpc.web_subnet_1b_id
  web_sg                    = module.sg.web_sg
  key_name                  = module.key.key_name
  instance_type             = var.instance_type
  project_name              = var.project_name
  environment               = var.environment
  ami_id                    = var.ami_id
  app_alb_dns_name          = module.alb-app.app_alb_dns_name
  iam_instance_profile_name = module.iam.ssm_instance_profile_name
  ebs_kms_key_arn           = module.kms.ebs_kms_key_arn
}

module "ec2-app" {
  source                    = "../modules/ec2-app"
  app_subnet_1a_id          = module.vpc.app_subnet_1a_id
  app_subnet_1b_id          = module.vpc.app_subnet_1b_id
  app_sg                    = module.sg.app_sg
  key_name                  = module.key.key_name
  instance_type             = var.instance_type
  project_name              = var.project_name
  environment               = var.environment
  ami_id                    = var.ami_id
  iam_instance_profile_name = module.iam.ssm_instance_profile_name
  ebs_kms_key_arn           = module.kms.ebs_kms_key_arn
}


module "asg-web" {
  source              = "../modules/asg-web"
  project_name        = var.project_name
  web_launch_template = module.ec2-web.web_launch_template
  web_alb_tg_arn      = module.alb-web.web_alb_tg_arn
  web_subnet_1a_id    = module.vpc.web_subnet_1a_id
  web_subnet_1b_id    = module.vpc.web_subnet_1b_id
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
}

module "asg-app" {
  source              = "../modules/asg-app"
  project_name        = var.project_name
  app_launch_template = module.ec2-app.app_launch_template
  app_alb_tg_arn      = module.alb-app.app_alb_tg_arn
  app_subnet_1a_id    = module.vpc.app_subnet_1a_id
  app_subnet_1b_id    = module.vpc.app_subnet_1b_id
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
}

# Creating external Application Load balancer

module "alb-web" {
  source           = "../modules/alb-web"
  vpc_id           = module.vpc.vpc_id
  web_subnet_1a_id = module.vpc.web_subnet_1a_id
  web_subnet_1b_id = module.vpc.web_subnet_1b_id
  web_alb_sg       = module.sg.web_alb_sg
  project_name     = var.project_name
  environment      = var.environment
}

# Creating internal Application Load balancer

module "alb-app" {
  source           = "../modules/alb-app"
  vpc_id           = module.vpc.vpc_id
  app_subnet_1a_id = module.vpc.app_subnet_1a_id
  app_subnet_1b_id = module.vpc.app_subnet_1b_id
  app_alb_sg       = module.sg.app_alb_sg
  project_name     = var.project_name
  environment      = var.environment
}

output "web_alb_dns_name" {
  value = module.alb-web.web_alb_dns_name
}

/*
# create cloudfront distribution 

module "cloudfront" {
  source = "../modules/cloudfront"
  certificate_domain_name = var.certificate_domain_name
  alb_domain_name = module.alb.alb_dns_name
  additional_domain_name = var.additional_domain_name
  project_name = module.vpc.project_name
}

# Add record in route 53 hosted zone

module "route53" {
  source = "../modules/route53"
  cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id
}
*/