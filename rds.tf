provider "aws" {
  access_key = "AKIARNIFKDOE3VJYELFM"
  secret_key = "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"
  region     = "us-east-2"

}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

resource "aws_db_instance" "default" {
  identifier = "demodb-oracle" 
  engine            = "oracle-se"
  engine_version    = "11.2.0.4.v24"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_encrypted = false
  license_model     = "bring-your-own-license"
  name                                = "oradb01"
  username                            = "oradbadmin"
  password                            = "AdminDB1234"
  port                                = "1521"
  iam_database_authentication_enabled = false
  character_set_name = "AL32UTF8"
  deletion_protection = false
  backup_retention_period = 0
}
#  vpc_security_group_ids = [data.aws_security_group.default.id]
#  subnet_ids = data.aws_subnet_ids.all.ids

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terra-backend-bkt"
    key            = "global/s3/v2/terraform.tfstate"
    region         = "us-east-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-lock-db-test"
    encrypt        = true
  }
}
