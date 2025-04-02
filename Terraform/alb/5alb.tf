resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}


# resource "aws_instance" "myinstance" {
#    ami                     = var.ami_id
#    instance_type           = var.instance_type  
#    
#    tags = var.tags
# 
#  } 

#  output "aws_instance_info" { 
#    value = aws_instance.myinstance
#  }

# resource "aws_route53_record" "record" {
#   for_each = aws_instance.instances #You can give like this also
#   zone_id = #give hosted zone id
#   name    = "${var.instance_name[count.index]}.joindevops.online" #interpolation ie fixed value "joindevops.online" is combined with variable
#   type    = "A"
#   ttl     = 1
#   records = [ each.key == "web" ? each.value.public_ip : each.value.private_ip ]
# }