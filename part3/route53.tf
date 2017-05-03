### Route53
### file route53.tf
### Route 53 record for Web Server

resource "aws_route53_record" "web" {
	zone_id = "PLACEHOLDER"
	name = "web.hellocloud-tutorial.io"
	type = "CNAME"
	ttl = "300"
	records = ["${aws_instance.tutorial.public_dns}"]
}
