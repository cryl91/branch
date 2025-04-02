variable "instance_name"{ 
    default = "mongodb"
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
        name = "web"
        Envirnoment = "dev"
    
    }
}

#This is key value pair
variable "instances" {
   type = map 
   default = {
   mongodb = "t2.micro"
   mysql = "  t2.micro" 
   }
}

variable "default_subnet11"{
    default = "subnet-0681e1e3a08354aa7"
}

variable "default_subnet22"{
    default = "subnet-011e86df5b3dd7968"
}


#This is how you define list/Array
#variable "azs" {
# default = ["us-east-1a", "us-east-1b"]
# }

#This is how you define list/Array
#variable "subnet" {
# default = ["10.0.0.1/24", "10.0.0.2/24"]
# }