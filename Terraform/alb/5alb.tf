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

#Target Group
resource "aws_lb_target_group" "catalogue" {
  name     = "catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-0dfc63964a304e93b"
  #Enable a health check
  health_check {
    enabled = true
    healthy_threshold = 2 #consider as health if 2 health check are success ie url is called 2 times and if both times url is not responding then its unhealthy
    interval = 15
    matcher = "200-299"
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 5 #if you dont get response within 5 seconds then we can consider it as failure
    unhealthy_threshold = 3 #3 consecutive requests fail, then it is unhealthy
  
  }
}

#Create launch template
resource "aws_launch_template" "catalogue" {
  name = "catalogue"

  image_id = "ami-08b5b3a93ed654d19"

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"

  
  vpc_security_group_ids = [aws_security_group.sg_alb.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Catalogue"
    }
  }

#user_data = filebase64("${path.module}/catalogue.sh") #create a catalogue.sh file in the same directory to run shell commands once the instance is created
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