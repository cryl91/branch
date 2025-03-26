variable "instance_name"{ 
    default = ["mongodb", "cart", "catalogue", "user", "reddis", "mysql", "rabbitmq", "shipping", "payment", "web"]
}
 

variable "ami_id"{
type = string
default = "ami-08b5b3a93ed654d19"
}

variable "instance_type"{
type = string
default = "t2.micro"
}

variable "tags" {
    type = map
    default = { 
        name = "mongodb"
        Envirnoment = "dev"
    
    }
}