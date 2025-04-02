  resource "aws_lb" "alb" {
    name               = "alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.sg_alb.id]
    subnets            = [var.default_subnet11, var.default_subnet22]
    
  #   enable_deletion_protection = true
    tags = {
      Environment = "security group alb"
    }
  }

resource "aws_lb_listener" "listener1" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  
  #This will add one listener on port no 80 and one default rule
  default_action {
    type = "fixed-response"

    
  fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }

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