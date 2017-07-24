provider "aws" {
  region = "us-west-2"
}

variable "aws_key_pair" {}
variable "product" {}

resource "aws_security_group" "web" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "dev" {
  ami             = "ami-6df1e514"
  instance_type   = "t2.micro"
  key_name        = "${var.aws_key_pair}"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]

  tags {
    Name = "dev.${var.product}.liatr.io"
  }

  provisioner "file" {
    source = "${path.module}/tomcat.conf"
    destination = "~"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  provisioner "remote-exec" {
    script = "${path.module}/install-tomcat.sh"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }
}

resource "aws_instance" "qa" {
  ami             = "ami-6df1e514"
  instance_type   = "t2.micro"
  key_name        = "${var.aws_key_pair}"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]

  tags {
    Name = "qa.${var.product}.liatr.io"
  }

  provisioner "file" {
    source = "${path.module}/tomcat.conf"
    destination = "~"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  provisioner "remote-exec" {
    script = "${path.module}/install-tomcat.sh"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }
}

resource "aws_instance" "prod" {
  ami             = "ami-6df1e514"
  instance_type   = "t2.micro"
  key_name        = "${var.aws_key_pair}"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]

  tags {
    Name = "${var.product}.liatr.io"
  }

  provisioner "file" {
    source = "${path.module}/tomcat.conf"
    destination = "~"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  provisioner "remote-exec" {
    script = "${path.module}/install-tomcat.sh"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }
}

data "aws_route53_zone" "liatrio" {
  name = "liatr.io"
}

resource "aws_route53_record" "dev" {
  zone_id = "${data.aws_route53_zone.liatrio.zone_id}"
  name    = "dev.${var.product}.liatr.io"
  type    = "A"
  ttl     = 300
  records = ["${aws_instance.dev.public_ip}"]
}

resource "aws_route53_record" "qa" {
  zone_id = "${data.aws_route53_zone.liatrio.zone_id}"
  name    = "qa.${var.product}.liatr.io"
  type    = "A"
  ttl     = 300
  records = ["${aws_instance.qa.public_ip}"]
}

resource "aws_route53_record" "prod" {
  zone_id = "${data.aws_route53_zone.liatrio.zone_id}"
  name    = "${var.product}.liatr.io"
  type    = "A"
  ttl     = 300
  records = ["${aws_instance.prod.public_ip}"]
}

