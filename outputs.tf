output "cluster_name" {
  value = module.eks.cluster_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "URL" {
  value = "http://${kubernetes_ingress_v1.ophirs_ingress.status[0].load_balancer[0].ingress[0].hostname}"
}
output "ingress_sg" {
  value = tolist(data.aws_lb.alb.security_groups)[0]
}