resource "aws_instance" "bastion" {
  depends_on             = ["aws_internet_gateway.igw"]

  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "${var.Types["Bastion"]}"
  key_name        = "${var.Key}"

  subnet_id              = "${aws_subnet.subnets-public.*.id[0]}"

  user_data              = "${file("assets/bastion.sh")}"
  vpc_security_group_ids = ["${aws_security_group.bastion-sg.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 10
  }

  tags {
    Type = "bastion"
    Name = "Bastion"
  }
}