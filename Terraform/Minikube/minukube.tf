module "minikube" {
  source = "github.com/scholzj/terraform-aws-minikube"

  aws_region    = "us-east-1"
  cluster_name  = "roboshop"
  aws_instance_type = "t2.medium"
  # ~ -> means home directory(/c/Users/user). So you should have terraform.pub in your home directory
  ssh_public_key = "~/terraform.pub"
  aws_subnet_id = "subnet-0681e1e3a08354aa7"
  hosted_zone = "example.com"
  # hosted_zone = "jointdevops.online"
  hosted_zone_private = false

  tags = {
    Application = "Minikube"
  }

  addons = [
      "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/kubernetes-dashabord/init.sh",
      "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/kubernetes-metrics-server/init.sh",
      "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/external-dns/init.sh",
      "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/kubernetes-nginx-ingress/init.sh"
  ]
}