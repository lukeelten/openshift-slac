resource "aws_subnet" "subnets-public" {
  count = "${length(data.aws_availability_zones.frankfurt.names)}"

  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${data.aws_availability_zones.frankfurt.names[count.index]}"

  cidr_block              = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, (1 + count.index))}"
  map_public_ip_on_launch = true

  tags {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_route_table_association" "public-to-rt" {
  count = "${aws_subnet.subnets-public.count}"

  subnet_id      = "${aws_subnet.subnets-public.*.id[count.index]}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_subnet" "subnets-private" {
  count = "${length(data.aws_availability_zones.frankfurt.names)}"

  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${data.aws_availability_zones.frankfurt.names[count.index]}"

  cidr_block              = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, (4 + count.index))}"
  map_public_ip_on_launch = false

  tags {
    Name = "Private Subnet ${count.index}"
  }
}

resource "aws_route_table_association" "private-to-rt" {
  count = "${aws_subnet.subnets-private.count}"

  subnet_id      = "${aws_subnet.subnets-private.*.id[count.index]}"
  route_table_id = "${aws_vpc.vpc.main_route_table_id}"
}

resource "aws_nat_gateway" "private-nat" {
  depends_on      = ["aws_internet_gateway.igw"]

  allocation_id = "${aws_eip.nat-eip.id}"
  subnet_id     = "${aws_subnet.subnets-public.*.id[(aws_subnet.subnets-public.count % 1)]}"

  tags {
    Name = "Private NAT"
  }
}

resource "aws_eip" "nat-eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.igw"]

  tags {
    Name = "NAT Internet IP"
  }
}

resource "aws_route" "private_route_to_nat" {
  route_table_id  = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.private-nat.id}"
}