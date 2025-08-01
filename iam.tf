data "aws_iam_policy_document" "alb_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:aws-load-balancer-controller"]
    }
  }
}

# Create IAM Role
resource "aws_iam_role" "alb_ingress_controller" {
  name               = "${var.cluster_name}-alb-ingress-controller"
  assume_role_policy = data.aws_iam_policy_document.alb_assume_role_policy.json
  tags               = var.tags
}

# Attach required policy
resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
  role       = aws_iam_role.alb_ingress_controller.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}

# Service Account with IRSA annotation
resource "kubernetes_service_account" "alb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_ingress_controller.arn
    }
  }
}