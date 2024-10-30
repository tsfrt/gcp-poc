variable "cluster_name" {
  type        = string
  description = "vpc, subnet and gke cluster name"
}

variable "k8s_version" {
  type        = string
  description = "kubernetes version"
  default     = "1.31.1-gke.2008000"
}

variable "region" {
  type        = string
  description = "gcp region where the gke cluster must be created, this region should match where you have created the vpc and subnet"
  default     = "us-east4"
}

variable "cidrBlock" {
  type        = string
  description = "The cidr block for subnet"
  default     = "10.1.0.0/16"
}

variable "nodepools" {
  description = "Nodepools for the Kubernetes cluster"
  type = map(object({
    name         = string
    node_count   = number
    node_labels  = map(any)
    machine_type = string
  }))
  default = {
    worker = {
      name         = "worker"
      node_labels  = { "worker-name" = "worker" }
      machine_type = "n1-standard-1"
      node_count   = 1
    }
  }
}

variable "mongo_machine_type" {
  type        = string
  description = "machine type for mongo instance"
  default = "e2-standard-2"
}

variable "mongo_db_instance" {
  type        = string
  description = "name of mongo db vm instance"
  default = "mongo-db-1"
}