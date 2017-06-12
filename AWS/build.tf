provider "aws" {
  access_key = "AKIAINV4NWYDHI5B74OA"
  secret_key = "Reqr8HgsFza8ffV0QLCED5gLB3n7RD2IyZ1QQASF"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}
