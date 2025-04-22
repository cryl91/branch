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
        name = "mongodb"
        Envirnoment = "dev"
    
    }
}

#This is how you define list/Array
#variable "azs" {
# default = ["us-east-1a", "us-east-1b"]
# }

#This is how you define list/Array
#variable "subnet" {
# default = ["10.0.0.1/24", "10.0.0.2/24"]
# }