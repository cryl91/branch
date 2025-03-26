resource "aws_instance" "myinstance" {
   count = "1"
   ami                     = local.ami_id
   instance_type           = "t2.micro"
   security_groups = [aws_security_group.sg.name]
 } 

 resource "aws_key_pair" "key" {
  key_name   = "linux_pub"
  public_key = local.pub_key 

}