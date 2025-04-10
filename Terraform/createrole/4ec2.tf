//Creating role


resource "aws_iam_role" "ec2" {
  name = "ec2_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
//Manily provide the policy arn like below to give premissions to role
//managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"]
  tags = {
    Terraform = "true"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_access" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

# Create Instance Profile. aws_iam_instance_profile needed?
//EC2 instances can’t directly use IAM roles.
//Instead, they use an instance profile, which acts as a "wrapper" for the role.
//This profile is then attached to the EC2 instance to allow it to assume the IAM role.

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2.name
}

resource "aws_instance" "myinstance" {
   ami                     = var.ami_id
   instance_type           = var.instance_name == "mongodb" ? "t2.micro" : "t2.small"
   iam_instance_profile = aws_iam_instance_profile.ec2_profile.name 
   tags = var.tags
 }  

 