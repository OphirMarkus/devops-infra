output "cluster_name" {
  value = module.eks.cluster_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "node_sg_id" {
  value = module.eks.node_security_group_id
}

# output "service_url" {
#   value       = "https://${kubernetes_service.ophirs_counter_service.status.0.load_balancer.0.ingress.0.hostname}"
#   description = "The external URL of the LoadBalancer service"
# }

output "k8s_metadata" {
  value = kubernetes_ingress_v1.ophirs_ingress.metadata
}
