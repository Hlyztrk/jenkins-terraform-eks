terraform {
    backend "s3" {
      bucket = "terraform-state-bucket-2709"
      key = "terraform.tfstate"
      region = "eu-west-1"
    }

}