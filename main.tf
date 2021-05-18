provider "aws" {
    region = var.region
}

resource "aws_security_group" "ec2_public_security_group3" {
  name        = "Amazon Linux 2 AMI"
  description = "Internet reaching access for EC2 Instances"
  vpc_id      = "vpc-a78246c1"

  ingress {
    from_port   = 8080
    protocol    = "TCP"
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkinsec2-dev3" {
    instance_type = var.instance_type
    ami = var.ami_id
    key_name = "linux-key"
    security_groups = ["${aws_security_group.ec2_public_security_group3.name}"]
    user_data = <<-EOF
		#! /bin/bash
                sudo yum update -y
		sudo yum install -y httpd.x86_64
		sudo service httpd start
		sudo service httpd enable
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
    yum install java-1.8.0-openjdk-devel -y
    curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
    sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
    yum install -y jenkins
    systemctl start jenkins
    systemctl status jenkins
    systemctl enable jenkins
	   EOF

    tags = {
      Name = "Deploy-Jenkins4",
      LOB = var.lob_dev
  }
}
