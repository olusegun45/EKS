# create an admin role

resource "aws_iam_role" "iam_role_admin" {
  name = "iam_role_admin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "CSD-instance_profile" {
  name = "CSD-instance-profile"
  role = aws_iam_role.iam_role_admin.name
}

resource "aws_iam_policy" "iam_policy_admin" {
  name = "iam_policy_admin"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "*",
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "iam_role_admin_attachment" {
  role = aws_iam_role.iam_role_admin.name
  policy_arn = aws_iam_policy.iam_policy_admin.arn
}

# Attach this Role to the EC2 Instance