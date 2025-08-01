# devops-infra
Checkpoint Exem DevOps Infrastructure

1. Creating a S3 Bucket to host my Terraform State:
    - I have used a Terraform file to set up my bucket and dynamodb table and applied it once to create my resources.
    - The file is commented out because it should run once to create the backend and not deleted. Uncomment the file to create a new backend if deleted.
    - with the Backend block, I can reference this S3 Bucket and set it as my state remote location.

2. Creating my tf files:
    - I set up the tf files that would create everything on the AWS cloud
        - providers.tf:  Required providers and Backend blocks.
        - variables.auto.tf: Contains Variables used in any other file.
        - main.tf: VPC and EKS cluster and k8s deployment creation steps.
        - iam.tf: configs IAM policies and rules.
        - alb.tf: configs ALB Controller and ingress.
        - outputs.tf: Output variables of the application of the configuration.

    I have commented out iam and alb and put them back into main in hopes things would work again but it seems I have errors that are deep in the cloud so it didn't really help

3. GitHub Actions:
    - I wrote a GitHub Actions pipeline that acts on push to the main and CI/CD branches
        - Configures AWS credentials
        - Installs Terraform
        - Initiates Terraform
        - Checks for formatting 
        - Shows changes to be made
        - If the push is to branch "main": apply then destroy (destroy for cleanup purposes)

# Major Errors
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


2. can't get access to K8S app
    After creating all network objects needed to access my app. I have discovered that the IAM rule that i was trying to create to allow access to port 80 from the internet was not getting created.

    I have tried countless ways including changing my architecture a few times but to no avail.
    It seems to me i just can't create any rule that has ingress from the internet, this makes me think it is an organization wide policy that prevents me from doing so again.

    After talking to Boris, I tried creating the rule with a cidr of my IP address only, this worked and i could access my application

3. Can't fully destroy
    An internet gateway is refusing to delete because it has mapped public addresses that im likely not authorized to delete. 
    
    --- Unsolved ---


# My Thoughts
The errors and problems I have encountered that had to do with an inability to create or delete reasources have consumed huge amounts of my time and got me to a point where my code is not how i would've wanted it to look like.
I have invested many hours in this project and after a lot of hard work I am happy with the end product.

I have really enjoyed the opportunity to do something like this, I have learned a lot even though things didn't work out for me a most of the time.
I was introduced to Terraform and IaC on the AWS in the most effective way, which I'm very happy about.

One thing I think is missing is more specific guidelines or instructions on what you can or can't do, many times I had problems with permissions that don't trigger an error, so debugging and investigating consumed a lot of my time.
In addition to that I would recommend testing the user against an automation written previously to determine whether or not the user still has sufficient permissions to complete the tasks in this exam.

I would say the whole thing took me 20 hours.