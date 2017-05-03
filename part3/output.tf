output "site_bicket" {
	value = "${aws_s3_bucket_object.site_object.bucket}"
}

output "ami" {
	value = "${var.ami}"
}

output "key_name" {
	value = "${var.key_name}"
}

output "key_file" {
	value = "${var.key_file}"
}

output "iam_instance_profile" {
	value = "${aws_iam_instance_profile.bucket_access_instance_profile.name}"
}

output "tutorial_public_ip" {
  value = "${aws_instance.tutorial.public_ip}"
}
