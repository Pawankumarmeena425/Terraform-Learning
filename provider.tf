provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""

  # This is the bad practice always configure aws by running command on CLI : "aws configure"   then put access_key and secret_key there.
}