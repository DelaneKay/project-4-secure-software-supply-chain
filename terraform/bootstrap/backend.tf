terraform {
  backend "s3" {
    region       = "us-east-1"
    key          = "bootstrap/terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
}
