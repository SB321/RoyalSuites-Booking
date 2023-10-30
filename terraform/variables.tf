variable "key_pair_name" {

    type    = string
    default = "terraformkeypair"
}

variable "public_key" {

    type    = string
    default = "Public Key"
}

variable "ami_id" {

    description = "AMI to use"
    default = "ami-0287a05f0ef0e9d9a"
}


variable "instance_type" {

    default = "t2.micro"
}

variable "number_of_instances" {

    description = "specify number of instances to be created"
    default = 1
}
