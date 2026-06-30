resource "aws_iam_role" "ec2_role" {
  name               = "${var.name}-role"
  assume_role_policy = var.assume_role_policy_json
}

resource "aws_iam_policy" "ec2_policy" {
  name   = "${var.name}-policy"
  policy = var.ec2_policy_json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.name}-instance-profile"
  role = aws_iam_role.ec2_role.name
}

