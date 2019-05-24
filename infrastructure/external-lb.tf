
resource "aws_lb" "external-lb" {
  depends_on      = ["aws_internet_gateway.igw"]
  name = "openshift-external-lb"
  load_balancer_type = "network"

  subnets = ["${aws_subnet.subnets-public.*.id}"]

  tags {
    Type = "external"
    Name = "Public LB"
  }
}

resource "aws_lb_target_group" "external-tg-http" {
  name     = "openshift-external-tg-http"
  port     = 80
  protocol = "TCP"
  vpc_id   = "${aws_vpc.vpc.id}"

  tags {
    Name = "Public HTTP Traffic"
  }

  health_check {
    protocol = "TCP"
    interval = 10
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "external-tg-https" {
  name     = "openshift-external-tg-https"
  port     = 443
  protocol = "TCP"
  vpc_id   = "${aws_vpc.vpc.id}"

  tags {
    Name = "Public HTTPS Traffic"
  }

  health_check {
    protocol = "TCP"
    interval = 10
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "external-tg-master" {
  name     = "openshift-external-tg-master"
  port     = 8443
  protocol = "TCP"
  vpc_id   = "${aws_vpc.vpc.id}"

  tags {
    Name = "Public Master Traffic"
  }

  health_check {
    protocol = "TCP"
    interval = 10
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "external-listener-master" {
  load_balancer_arn = "${aws_lb.external-lb.arn}"
  port              = "8443"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.external-tg-master.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "external-listener-http" {
  load_balancer_arn = "${aws_lb.external-lb.arn}"
  port              = "80"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.external-tg-http.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "external-listener-https" {
  load_balancer_arn = "${aws_lb.external-lb.arn}"
  port              = "443"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.external-tg-https.arn}"
    type             = "forward"
  }
}