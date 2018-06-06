# Create db instance 


#make db subnet group 
resource "aws_db_subnet_group" "dbsubnet" {
  name       = "main"
  subnet_ids = ["${aws_subnet.db_subnet1.id}", "${aws_subnet.db_subnet2.id}"]
}

#provision the database
resource "aws_db_instance" "wpdb" {
  identifier = "wpdb"
  instance_class = "db.m4.large"
  allocated_storage = 50
  engine = "mysql"
  name = "wordpress"
  password = "${var.db_password}"
  username = "${var.db_user}"
  # If using Symphony, use 5.7.00, otherwise us AWS reccomended version 
  #engine_version = "5.7.00"
  engine_version = "5.7.21"
  skip_final_snapshot = true
  db_subnet_group_name = "${aws_db_subnet_group.dbsubnet.name}"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  # Workaround for Symphony 
  #lifecycle {
  #  ignore_changes = ["engine", "auto_minor_version_upgrade"]
  #}
}

resource "aws_security_group" "db" {
  name = "db-secgroup"
  vpc_id = "${aws_vpc.app_vpc.id}"

  # ssh access from anywhere
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}