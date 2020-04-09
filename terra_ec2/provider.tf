provider "aws" {
  region="ap-south-1"
  access_key = "" #add access key here
  secret_key = "" # add secret key here
}

#Select KeyPair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = ""
}