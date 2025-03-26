variable "instance_name"{ 
    type = list
    default = ["mongodb", "cart", "catalogue", "user", "reddis", "mysql", "rabbitmq", "shipping", "payment", "web"]
}
 

variable "ami_id"{
type = string
default = "ami-08b5b3a93ed654d19"
}
