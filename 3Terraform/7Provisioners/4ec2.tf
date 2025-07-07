#This is Local Exec
resource "aws_instance" "myinstance" {
   ami                     = var.ami_id
   instance_type           = var.instance_type
   #instance_type = data.aws_ssm_parameter.instance_type.value #to use the parameter store value 
    tags = var.tags
//local-exec runs on the machine where Terraform is executed ie  Will run on yourterraform server, not on the EC2 instance you're creating
  provisioner "local-exec" {
    command = "echo ${self.private_ip} > file1"
  } 
} 

#This is Remote Exec
resource "aws_instance" "remote" {
  ami                     = var.ami_id
  instance_type           = var.instance_type

//to connect to remote server
  connection {
    type     = "ssh"
    user     = "root"
    password = "devops123"
  //private_key = file("Private-key") = Reads the private SSH key file and Allows Terraform to SSH into the EC2 instance. While user_data = file("install.sh") Reads the shell script (install.sh) and passes it as user data and the script runs on the EC2 instance at launch
    host     = self.public_ip //In the connection block in Terraform (used with provisioners like remote-exec), the host parameter tells Terraform where to connect — i.e., the IP address or DNS name of the remote machine (like an EC2 instance). Self meanas a shortcut to refer to the current resource (aws_instance.myinstance in this case). Here it Gets the public IP address assigned to the EC2 instance when it was created.
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx",
      "sudo systemctl start nginx",
    ]
  }
}
