
resource "aws_route53_record" "router-record" {
  zone_id = "${data.aws_route53_zone.existing-zone.zone_id}"
  name    = "*.apps.${data.aws_route53_zone.existing-zone.name}"
  type = "CNAME"

  ttl = "300"
  records = ["${aws_instance.infra-node.*.public_dns[0]}"]
}

resource "aws_route53_record" "master-record" {
  zone_id = "${data.aws_route53_zone.existing-zone.zone_id}"
  name    = "master.${data.aws_route53_zone.existing-zone.name}"
  type = "CNAME"

  ttl = "300"
  records = ["${aws_instance.master-node.*.public_dns[0]}"]
}

resource "aws_route53_record" "internal-api-record" {
  zone_id = "${data.aws_route53_zone.existing-zone.zone_id}"
  name    = "internal-master.${data.aws_route53_zone.existing-zone.name}"
  type = "CNAME"

  ttl = "300"
  records = ["${aws_instance.master-node.*.private_dns[0]}"]
}

resource "aws_route53_record" "bastion-record" {
  zone_id = "${data.aws_route53_zone.existing-zone.zone_id}"
  name    = "bastion.${data.aws_route53_zone.existing-zone.name}"
  type = "CNAME"

  ttl = "300"
  records = ["${aws_instance.bastion.public_dns}"]
}

resource "aws_route53_record" "app-records" {
  zone_id = "${data.aws_route53_zone.existing-zone.zone_id}"
  name    = "app${count.index}.${data.aws_route53_zone.existing-zone.name}"
  type = "CNAME"

  count = "${var.Counts["App"]}"

  ttl = "300"
  records = ["${aws_instance.app-node.*.private_dns[count.index]}"]
}

resource "aws_route53_record" "master-nodes-records" {
  zone_id = "${data.aws_route53_zone.existing-zone.zone_id}"
  name    = "master${count.index}.${data.aws_route53_zone.existing-zone.name}"
  type = "CNAME"

  count = "${var.Counts["Master"]}"

  ttl = "300"
  records = ["${aws_instance.master-node.*.private_dns[count.index]}"]
}

resource "aws_route53_record" "infra-nodes-records" {
  zone_id = "${data.aws_route53_zone.existing-zone.zone_id}"
  name    = "infra${count.index}.${data.aws_route53_zone.existing-zone.name}"
  type = "CNAME"

  count = "${var.Counts["Infra"]}"

  ttl = "300"
  records = ["${aws_instance.infra-node.*.private_dns[count.index]}"]
}