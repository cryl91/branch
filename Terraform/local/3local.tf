#locals are similar to variable but they also allow expressions and functions
locals {
  ami_id = "ami-08b5b3a93ed654d19"
  pub_key = file("${path.module}/Linux.pub")
}