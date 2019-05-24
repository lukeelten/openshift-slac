resource "aws_instance" "app-node" {
  depends_on      = ["aws_internet_gateway.igw", "aws_nat_gateway.private-nat", "aws_route.private_route_to_nat"]

  ami             = "${data.aws_ami.centos.id}"
  instance_type   = "${var.Types["App"]}"
  key_name        = "${var.Key}"
  user_data       = "${file("assets/init.sh")}"

  vpc_security_group_ids = ["${aws_security_group.nodes-sg.id}"]
  subnet_id = "${aws_subnet.subnets-private.*.id[(count.index % aws_subnet.subnets-private.count)]}"

  count = "${var.Counts["App"]}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }

  ebs_block_device {
    delete_on_termination = true
    volume_type ="gp2"
    volume_size = 500
    device_name = "/dev/sdb"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Type = "app"
    Name = "App ${count.index + 1}"
  }
}
