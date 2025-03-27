variable "instance_name"{ 
    default = "mongodb"
}
 

# variable "ami_id"{
# type = string
# default = "ami-08b5b3a93ed654d19"
# }


variable "instances" {
   type = map 
   default = {
   mongodb = "t2.micro"
   mysql = "  t2.micro" 
   }
}
