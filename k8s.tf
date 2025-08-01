data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

locals {
  ecr_registry = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/counter-service:latest"
}

# Deploy application on pods in new worker nodes
resource "kubernetes_deployment" "ophirs_counter_service_new" {
  metadata {
    name = var.cluster_name
    labels = {
      app = var.cluster_name
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = var.cluster_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.cluster_name
        }
      }
      spec {
        container {
          image = local.ecr_registry
          name  = var.cluster_name

          port {
            container_port = var.port
          }
        }
      }
    }
  }
  depends_on = [module.eks]
}

# Add service
resource "kubernetes_service" "ophirs_counter_service" {
  metadata {
    name = var.cluster_name
  }

  spec {
    selector = {
      app = var.cluster_name
    }

    port {
      port        = var.port
      target_port = var.port
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}