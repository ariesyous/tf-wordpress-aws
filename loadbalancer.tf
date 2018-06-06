
#Provision load balancer and associated security group

###############################################
## SECURITY GROUP DEFINITION 
###############################################

resource "aws_security_group" "lb-sec" {
  name = "lb-secgroup"
  vpc_id = "${aws_vpc.app_vpc.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #ping from anywhere
    ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

###############################################
## NLB CONFIGURATION 
###############################################

# NLB definition
resource "aws_lb" "web-lb" {
  name = "web-lb-tf"
  internal = false
  load_balancer_type = "network"
  subnets = ["${aws_subnet.pub_subnet1.id}","${aws_subnet.pub_subnet2.id}"]
}
#Target group definition for NLB
resource "aws_lb_target_group" "targetgrp" {
  port = 8080
  protocol = "TCP"
  vpc_id = "${aws_vpc.app_vpc.id}"
}

# NLB attachment
resource "aws_lb_target_group_attachment" "attach_web" {
  target_group_arn = "${aws_lb_target_group.targetgrp.arn}"
  target_id = "${element(aws_instance.web-server.*.id, count.index)}"
  port = 8080
  count = "${var.web_number}"
}

# Listener for NLB
resource "aws_lb_listener" "webport" {
  load_balancer_arn = "${aws_lb.web-lb.arn}"
  port = 80
  protocol = "TCP"
   default_action {
    target_group_arn = "${aws_lb_target_group.targetgrp.arn}"
    type = "forward"
  }
}


###############################################
## ALB CONFIGURATION - Not working. Keep getting bad gateway errors. Went with NLB instead.
###############################################
/*
resource "aws_alb" "alb" {
  subnets = ["${aws_subnet.pub_subnet1.id}","${aws_subnet.pub_subnet2.id}"]
  internal = false
  security_groups = ["${aws_security_group.lb-sec.id}"]
}

resource "aws_alb_target_group" "targ" {
  port = 8080
  protocol = "HTTP"
  vpc_id = "${aws_vpc.app_vpc.id}"

  #workaround - won't be needed in 4.2.6
  lifecycle {
    ignore_changes = ["port", "target_type", "vpc_id"]
  }
}

resource "aws_alb_target_group_attachment" "attach_web" {
  target_group_arn = "${aws_alb_target_group.targ.arn}"
  target_id = "${element(aws_instance.web-server.*.id, count.index)}"
  port = 8080
  count = "${var.web_number}"
}

resource "aws_alb_listener" "list" {
  "default_action" {
    target_group_arn = "${aws_alb_target_group.targ.arn}"
    type = "forward"
  }
  load_balancer_arn = "${aws_alb.alb.arn}"
  port = 80
}

*/


