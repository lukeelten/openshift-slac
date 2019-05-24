resource "aws_security_group" "bastion-sg" {
  description = "Security Group for Bastion server"
  name        = "openshiftbastion-sg"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress = [
    {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      from_port        = "-1"
      to_port          = "-1"
      protocol         = "icmp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags {
    Name = "Bastion SG"
  }
}

resource "aws_security_group" "master-sg" {
  description = "Security Group for Master Nodes"
  name        = "openshiftmaster-sg"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress = [
    {
      from_port        = 8443
      to_port          = 8443
      protocol         = "tcp"
      // Should be restricted to master load balancer, but network lbs does not have security groups
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags {
    Name = "Master Nodes SG"
  }
}

resource "aws_security_group" "infra-sg" {
  description = "Security Group for Infrastructure Nodes"
  name        = "openshiftinfra-sg"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress = [
    {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      // Should be restricted to router lb
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      // Should be restricted to router lb
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags {
    Name = "Infrastructure Nodes SG"
  }
}

resource "aws_security_group" "nodes-sg" {
  description = "Security Group for Nodes"
  name        = "openshiftnodes-sg"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress = [
    {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      from_port        = 1
      to_port          = 65535
      protocol         = "tcp"
      self             = true
    },
    {
      from_port        = 1
      to_port          = 65535
      protocol         = "udp"
      self             = true
    },
    {
      from_port        = "-1"
      to_port          = "-1"
      protocol         = "icmp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags {
    Name = "Nodes SG"
  }
}
