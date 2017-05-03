### IAM
### file iam-roles.tf
### IAM profile and policy for S3 bucket access

resource "aws_iam_instance_profile" "bucket_access_instance_profile" {
  name = "bucket_access_instance_profile"
  roles = ["${aws_iam_role.bucket_access_role.name}"]
}

resource "aws_iam_role" "bucket_access_role" {
  name = "bucket_access_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "bucket_access_policy" {
  name = "bucket_access_policy"
  role = "${aws_iam_role.bucket_access_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": ["arn:aws:s3:::${var.s3SiteBucket}"]
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": ["arn:aws:s3:::${var.s3SiteBucket}/*"]
    }
  ]
}
EOF
}
