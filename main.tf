  resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = " DEvops-VPC789"

    }
  
}

resource "aws_subnet" "my-1st-sub" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/25"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "Sub-1=terraform"
  }
  
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.my-vpc.id
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
} 
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  
}  

resource "aws_route_table" "my-rt" {
  vpc_id = aws_vpc.my-vpc.id
  
}

resource "aws_route_table_association" "my-rt-asso" {
  route_table_id = aws_route_table.my-rt.id
  subnet_id = aws_subnet.my-1st-sub.id

}

resource "aws_route" "my-route" {
  route_table_id = aws_route_table.my-rt.id
  gateway_id = aws_internet_gateway.my-igw.id
  destination_cidr_block = "0.0.0.0/0" 
}

resource "aws_instance" "my-server" {
  ami = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.my-1st-sub.id
  
  
}
