resource "aws_instance" "master-node" {
  depends_on      = ["aws_nat_gateway.private-nat", "aws_route.private_route_to_nat"]

  ami             = "${data.aws_ami.centos.id}"
  instance_type   = "${var.Types["Master"]}"
  key_name        = "${var.Key}"
  user_data       = "${file("assets/init.sh")}"

  vpc_security_group_ids = ["${aws_security_group.nodes-sg.id}", "${aws_security_group.master-sg.id}"]
  subnet_id = "${aws_subnet.subnets-public.*.id[(count.index % aws_subnet.subnets-public.count)]}"

  count = "${var.Counts["Master"]}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Type = "master"
    Name = "Master Node ${count.index + 1}"
  }
}
