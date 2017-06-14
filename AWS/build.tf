resource "aws_instance" "mybuild" {
  ami           = "${lookup(var.ami, "${var.region}-${var.platform}")}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.mysg.id}"]
  subnet_id = "${aws_subnet.front_end.id}"
  depends_on = ["aws_internet_gateway.gw"]

  connection {
        user = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
  }
}

resource "aws_vpc" "TF_VPC" {
  cidr_block = "10.2.0.0/16"

  tags {
    Name = "My TF VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.TF_VPC.id}"

  tags {
    Name = "main"
  }
}

resource "aws_route_table" "public_access" {
  vpc_id = "${aws_vpc.TF_VPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_route_table_association" "assoc" {
  subnet_id      = "${aws_subnet.front_end.id}"
  route_table_id = "${aws_route_table.public_access.id}"
}


resource "aws_subnet" "front_end" {
  vpc_id     = "${aws_vpc.TF_VPC.id}"
  cidr_block = "10.2.1.0/24"
  map_public_ip_on_launch = "true"

  tags {
    Name = "Main"
  }
}



resource "aws_security_group" "mysg" {
    name = "mybuild_${var.platform}"
    vpc_id     = "${aws_vpc.TF_VPC.id}"
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
        cidr_blocks = ["188.65.56.229/32", "143.159.116.210/32"]
    }

    // This is for outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
