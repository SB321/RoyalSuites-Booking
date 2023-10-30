provider "aws" {

    region = "ap-south-1"

}

resource "aws_instance" "ec2_instance" {

    ami = "${var.ami_id}"
    instance_type = "${var.instance_type}"
    count = "${var.number_of_instances}"
    key_name = aws_key_pair.terraform_key_pair.key_name
    vpc_security_group_ids = [ "${aws_security_group.my_sg.id}" ]
    subnet_id = "${aws_subnet.my_subnet.id}"

    associate_public_ip_address = true

    tags = {
        
        "Name" : "ec2-server"
    }


}

resource "aws_key_pair" "terraform_key_pair" {
    
    key_name   = var.key_pair_name
    public_key = var.public_key

}

resource "aws_vpc" "my_vpc" {

    cidr_block = "10.0.0.0/16"

    tags = {

        Name = "terraform-vpc"
    }

}

resource "aws_subnet" "my_subnet" {

    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.0.0/24"

    tags = {

        Name = "terraform-subnet"
    }

}

resource "aws_internet_gateway" "terraform_ig" {

    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = "Terraform Internet Gateway"
    }
}

resource "aws_route_table" "public_rt" {

    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.terraform_ig.id
    }

    route {
        ipv6_cidr_block = "::/0"
        gateway_id      = aws_internet_gateway.terraform_ig.id
    }

    tags = {
        
        Name = "Route Table"
    }
}

resource "aws_route_table_association" "public_1_rt_a" {

    subnet_id      = aws_subnet.my_subnet.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "my_sg" {
    vpc_id = aws_vpc.my_vpc.id

    name        = "my-security-group"
    description = "Allow inbound SSH and HTTP traffic"
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
