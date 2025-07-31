# devops-infra
Checkpoint Exem DevOps Infrastructure

1. Creating a S3 Bucket to host my Terraform State:
    - I have used a Terraform file to set up my bucket and dynamodb table and applied it once to create my resources.
    - with the Backend block, I can reference this S3 Bucket and set it as my state remote location.

2. Creating my tf files:
    - I set up the providers, main, variables.auto and providers tf files
        - Providers.tf:  Required providers and Backend blocks.
        - variables.auto.tf: Contains Variables used in main.tf.
        - Main.tf: VPC and EKS cluster creation steps.
        - outputs.tf: Output variables of the application of the configuration.

# Errors
When working on this project I have dealt with a few errors

1. EKS cluster creation: Access Denied
    When running terraform apply for the first time, I have encountered the following error
    ```
    │ Error: creating EKS Cluster (counter-service-cluster): AccessDeniedException: User: arn:aws:iam::411202742861:user/devops-exam is not authorized to perform: eks:CreateCluster on resource: arn:aws:eks:us-east-1:411202742861:cluster/counter-service-cluster with an explicit deny
    │
    │   with module.eks.aws_eks_cluster.this[0],
    │   on .terraform\modules\eks\main.tf line 25, in resource aws_eks_cluster" "this":
    │   25: resource "aws_eks_cluster" "this"
    ```
    According to this error, my user did not have permissions to preform the eks:CreateCluster action. It seemed like an IAM rule was actively denying me from preforming this action.
    
    After searching for approximately 10m I contacted Boris asking him if i really might be blocked from preforming this action.
    
    While Boris Checked what the problem was, I tried different terraform configurations to see if there was a problem with my configuration that might have caused this error.
    None of those worked.

    As it turns out, an organization-wide policy was applied on the cloud preventing me from preforming this action.

2. 4 subnets that can't get destroyed