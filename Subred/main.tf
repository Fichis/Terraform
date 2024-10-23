terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Creación de un módulo, que es básicamente el recurso VPC
# Se le pasa un source, y para aplicarlo debes hacer terraform init otra vez.
module "vpc" {
  source = "../VPC - Ejemplo"
}

# Creación de la subred privada
resource "aws_subnet" "private_subnet" {
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.1.0/24" 

  # Poner un tag, para encontrar rápidamente cuál ha creado
  tags = {
    Name = "Private-DAW"
  }
}

#Creación de la subred pública
resource "aws_subnet" "public_subnet" {
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.101.0/24"
  map_public_ip_on_launch = true #Mapea una ip pública al crearse

  # Poner un tag, para encontrar rápidamente cuál ha creado
  tags = {
    Name = "Public-DAW"
  }
}