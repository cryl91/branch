data "aws_ami" "ami" {
    most_recent = true
    owners = ["amazon"] #you can give owner Account id(here aws account id)

filter {
  name = "name"
  values = ["al2023-ami-2023.6.20250303.0-kernel-6.1-x86_64"]

}
}

output "ami_id" {
  value = data.aws_ami.ami.id

}