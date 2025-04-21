resource "aws_instance" "myinstance" {
   count = "10"
   ami                     = var.ami_id
   instance_type           = var.instance_name[count.index] == "mongodb" ? "t2.small" : "t2.micro"
   
    # tags = {
    #   name = "mongodb"
    #   Envirnoment = "dev"
    # }

    tags = {
    name = var.instance_name[count.index]
 } 
}

# resource "aws_route53_record" "record" {
#   count = 10
#   zone_id = #give hosted zone id
#   name    = "${var.instance_name[count.index]}.joindevops.online" #interpolation ie fixed value "joindevops.online" is combined with variable
#   type    = "A"
#   ttl     = 1
#   records = [aws_instance.myinstance[count.index].private_ip]
# }