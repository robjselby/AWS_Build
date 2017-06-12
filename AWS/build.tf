resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"

  connection {
        user = "ubuntu"
        private_key = "${file("${var.key_path}")}"
}

}
