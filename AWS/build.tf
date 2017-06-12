resource "aws_instance" "mybuild" {
  ami           = "${lookup(var.ami, "${var.region}-${var.platform}")}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"

  connection {
        user = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
  }

}
