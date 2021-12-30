variable "ntier_vpc_cidr" {
    type = string
    default = "10.10.0.0/16"
}

variable "ntier_vpc_region" {
    type = string
    default = "us-west-2"
}

variable "ntier_subnet_az" {
    type = list(string)
    default = ["us-west-2a" , "us-west-2a" , "us-west-2a"]
  
}

variable "ntier_subnet_tags" {
    default = ["ntier-web" , "ntier-app" , "ntier-db"]
}

variable "web_subnet_index" {

    type = list(number)
    default = [ 0 ]
  
}

variable "app_subnet_index" {

    type = list(number)
    default = [ 1 ]
  
}