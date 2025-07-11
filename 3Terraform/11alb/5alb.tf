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

#Target Group = An AWS Target Group is a logical group of backend resources (typically EC2 instances, IP addresses, or Lambda functions) that an Elastic Load Balancer (ALB/NLB) sends traffic to.
#This defines a target group named "catalogue", which Listens on port 8080, Expects HTTP traffic and Belongs to a specific VPC. 
resource "aws_lb_target_group" "catalogue" {
  name     = "catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-0dfc63964a304e93b"
  #Health Check ensures only healthy targets get traffic = ALB will only send requests to EC2 instances that: Respond to /health, Return HTTP 2xx codes and Respond within 5 seconds. 
  health_check {
    enabled = true #Turns on health checking
    path = "/health" #Special endpoint used to report whether an application is healthy and ready to receive traffic. No, /health is not the endpoint that ALB sends regular traffic to. /health is used only for health checks by the ALB — not for serving actual user traffic.
    healthy_threshold = 2 #consider as health if 2 health check are success ie url is called 2 times and if both times url is not responding then its unhealthy
    interval = 15 #Check every 15 seconds
    matcher = "200-299" #Consider response "healthy" only if status is 2xx
    port = 8080
    protocol = "HTTP"
    timeout = 5 #if you dont get response within 5 seconds then we can consider it as failure
    unhealthy_threshold = 3 #3 consecutive requests fail, then it is unhealthy
  
  }
}

#Creating Listener
resource "aws_lb_listener" "listener1" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  
  #This will add one listener on port no 80 and one default rule
  default_action {
    type = "fixed-response" #If you dont have instance, but to check its working, it will display fixed-response

//Listens on a specific port (e.g., 80 for HTTP, 443 for HTTPS) and Defines a default action (e.g., return a fixed response, forward to a target group)    
  fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }

}
}

#Creating Listener's Rule = It defines path-based or host-based routing to a specific URL. Listener rule is optional unless you want routing.
resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.listener1.arn 
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.app.joindevops.online"] #This is the ALB endpoint where the requests are forwarded to. 
    } #path based means = values = ["/catalogue/*"]
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

#user_data = file("${path.module}/catalogue.sh") #The file() function in Terraform reads the contents of a local file and returns it as a string. Here Create a catalogue.sh file in the same directory to run shell commands once the instance is created
}

resource "aws_autoscaling_group" "aag" {
  name                      = "aag"
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  #Specify the target group - to link target group and autoscaling group
  target_group_arns = [aws_lb_target_group.catalogue.arn]
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [var.default_subnet11, var.default_subnet22]  

  timeouts {
    delete = "15m"
  }

}

resource "aws_autoscaling_policy" "aspolicy" {
  autoscaling_group_name = aws_autoscaling_group.aag.name
  name                   = "as_policy"
  policy_type            = "TargetTrackingScaling"
  # ... other configuration ...

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}


