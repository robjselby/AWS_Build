resource "aws_instance" "mybuild" {
  ami           = "${lookup(var.ami, "${var.region}-${var.platform}")}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.mysg.name}"]

  connection {
        user = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
  }
}

resource "aws_security_group" "mysg" {
    name = "mybuild_${var.platform}"
    description = "Internal traffic + maintenance."

    // These are for internal traffic
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        self = true
    }

    // These are for maintenance
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // This is for outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
