data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "ecs_cluster" {
  source      = "git::https://github.com/just-in-devops/def-platform-modules.git//modules/ecs-cluster?ref=v0.0.3"
  environment = "dev"
  mission     = "logistics"

  tags = {}
}

module "wiremock_service" {
  source = "git::https://github.com/just-in-devops/def-platform-modules.git//modules/ecs-service?ref=v0.0.3"

  environment  = "dev"
  mission      = "logistics"
  service_name = "wiremock"

  cluster_arn = module.ecs_cluster.cluster_arn

  network = {
    vpc_id     = data.aws_vpc.default.id
    subnet_ids = data.aws_subnets.default.ids
  }

  container = {
    image         = "wiremock/wiremock:3.3.1"
    cpu           = 256
    memory        = 512
    port          = 8080
    desired_count = 1
  }

  tags = {}
}

