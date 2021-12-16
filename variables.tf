variable "web_number" {
  type = number
  default = "1"
}
#variable "web_number2" {}
variable "web_ami" {
  type = string
  default = "ami-a4dc46db"
}
variable "web_instance_type" {
  type = string
  default = "t3.medium"
}

variable "db_password" {
  type = string
  default = "Cloud!Orchestration!"
}

variable "db_user" {
  type = string
  default = "dbadmin"
}



# Commenting out because Code Pipes will provide these by default

#variable "aws_secret_key" {}
#variable "aws_access_key" {}

#provider "aws" {

  #access_key = "${var.aws_access_key}"
  #secret_key = "${var.aws_secret_key}"
  #region = "us-east-1"
#}


