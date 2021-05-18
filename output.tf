output "publicip" {
    value = "${aws_instance.jenkinsec2-dev3.public_ip}"
}
