
provider "google" {}

module "environment" {
  source = "./env"

  region       = var.region
  cluster_name = var.cluster_name
  k8s_version  = var.k8s_version
}
