# # Install ALB Controller via Helm
# resource "helm_release" "aws_load_balancer_controller" {
#   name       = "aws-load-balancer-controller"
#   namespace  = "default"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   version    = "1.7.1"

#   values = [yamlencode({
#     clusterName = var.cluster_name
#     region      = var.region
#     vpcId       = module.vpc.vpc_id
#     serviceAccount = {
#       create = false
#       name   = kubernetes_service_account.alb_controller.metadata[0].name
#     }
#     ingressClass = "alb"
#   })]

#   depends_on = [
#     kubernetes_service_account.alb_controller
#   ]
# }

# resource "kubernetes_ingress_v1" "ophirs_ingress" {
#   metadata {
#     name      = var.cluster_name
#     namespace = "default"
#     annotations = {
#       "kubernetes.io/ingress.class"            = "alb"
#       "alb.ingress.kubernetes.io/scheme"       = "internet-facing"
#       "alb.ingress.kubernetes.io/target-type"  = "ip"
#       "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\": 80}]"
#     }
#   }

#   spec {
#     rule {
#       http {
#         path {
#           path      = "/*"
#           path_type = "ImplementationSpecific"

#           backend {
#             service {
#               name = var.cluster_name
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }