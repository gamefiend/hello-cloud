### S3
### file s3.tf
### S3 bucket for site index page

resource "aws_s3_bucket" "hellocloud-tutorial-site-bucket" {
    bucket = "hellocloud-tutorial-site"
    acl = "public-read"
    policy = <<EOF
{
  "Id": "Policy1462998290938",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1462998074852",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::hellocloud-tutorial-site/*",
      "Principal": "*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket_object" "site_object" {
    depends_on = ["aws_s3_bucket.hellocloud-tutorial-site-bucket"]
    bucket = "hellocloud-tutorial-site"
    key = "index.html"
    source = "s3/files/site/index.html"
    etag = "${md5(file("s3/files/site/index.html"))}"
}
