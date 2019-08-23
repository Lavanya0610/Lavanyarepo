provider "aws" {
	access_key = "AKIAZTIMJ7JHPVODYVZA"
	secret_key = "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"
	region = "eu-west-1"
}

resource "aws_instance" "Lavanyaterraform"{
	ami = "ami-0bbc25e23a7640b9b"
	instance_type = "t2.micro"

tags = {
	Name = "Lavanyainstance"
}
}

resource "aws_eip" "Lavanyatfeip" {
tags = {
Name = "Lavanyaeip"
}
instance = "${aws_instance.Lavanyaterraform1.id}"
}

resource "aws_instance" "Lavanyaterraform1"{
	ami = "ami-0bbc25e23a7640b9b"
	instance_type = "t2.micro"
key_name = "${aws_key_pair.Lavanyatfkey.id}"
tags = {
	Name = "Lavanyainstance"
}
vpc_security_group_ids = ["${aws_security_group.Lavanyatfsecgroup.id}"]

provisioner "local-exec"{
when = "create"
command = "echo ${aws_instance.Lavanyaterraform.public_ip}>sample.txt"
}

provisioner "chef" {
	connection {
	host = "${self.public_ip}"
	type = "ssh"
	user = "ec2-user"
	private_key = "${file("C:\\Lavanya\\puttykey.pem")}"
}
client_options = [ "chef_license 'accept'"]
run_list = ["testenv_aws_tf_chef::default"]
recreate_client = true
node_name = "lavanya06node"
server_url = "https://manage.chef.io/organizations/lavanya06"
user_name = "lavanya06"
user_key = "${file("C:\\Lavanya\\chef-starter\\chef-repo\\.chef\\lavanya06.pem")}"
ssl_verify_mode = ":verify_none"
}
}
resource "aws_security_group" "Lavanyatfsecgroup" {
	name = "Lavanyatfsecgroup"
	description = "Allow traffic"

	ingress{
from_port = "0"
to_port = "0"
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}

	egress{
from_port = "0"
to_port = "0"
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}

resource "aws_key_pair" "Lavanyatfkey" {
	key_name = "Lavanyakeypair"
	public_key = "${file("C:\\Lavanya\\Puttykey.pub")}"
}
output "Lavanyapubip" { 
value = "${aws_instance.Lavanyaterraform.public_ip}"
}

resource "aws_s3_bucket" "lavanyabuc"{
bucket = "lavanyabuck"
acl = "private"
force_destroy = "true"
}

terraform {
backend "s3" {
bucket = "lavanyabuck"
key = "terrafor.tfstate"
region = "eu-west-1"
}
}
