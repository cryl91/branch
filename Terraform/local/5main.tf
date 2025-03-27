resource "aws_instance" "myinstance" {
   ami                     = local.ami_id
   instance_type           = local.instance_type
    } 

 resource "aws_key_pair" "key" {
  key_name   = "linux_pub"
  public_key = local.pub_key 

}