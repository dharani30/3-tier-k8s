#Creating vpc
resource "aws_vpc" "Dharani-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true" #gives you an internal domain name
    enable_dns_hostnames = "true" #gives you an internal host name
    enable_classiclink = "false"
    instance_tenancy = "default"    
    
    tags {
        Name = "Dharani-vpc"
    }
}


#Creating public subnet - Management/Public Subnet

resource "aws_subnet" "Dharani-subnet-public-1" {
    vpc_id = "${aws_vpc.Dharani-vpc.id}"
    cidr_block = "10.0.1.0/24"
    #map_public_ip_on_launch = "true" 
    availability_zone = "us-east-1a"
    tags {
        Name = "Dharani-subnet-public-1"
    }
}

#Creating private subnet1 - masternode

resource "aws_subnet" "Dharani-subnet-private-1" {
    vpc_id = "${aws_vpc.Dharani-vpc.id}"
    cidr_block = "10.0.2.0/24"
    #map_public_ip_on_launch = "false" 
    availability_zone = "us-east-1b"
    tags {
        Name = "Dharani-subnet-private-1"
    }
}

#Creating private subnet2 - worker nodes

resource "aws_subnet" "Dharani-subnet-private-2" {
    vpc_id = "${aws_vpc.Dharani-vpc.id}"
    cidr_block = "10.0.3.0/24"
    #map_public_ip_on_launch = "false" 
    availability_zone = "us-east-1c"
    tags {
        Name = "Dharani-subnet-private-2"
    }
}
#Creating Internet Gateway for external communication
resource "aws_internet_gateway" "Dharani-igw" {
    vpc_id = "${aws_vpc.Dharani-vpc.id}"
    tags {
        Name = "Dharani-igw"
		BuildWith = "terraform"
    }
}

# create external route to IGW
resource "aws_route" "external_route" {
  route_table_id         = "${ aws_vpc.Dharani-vpc.main_route_table_id }"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${ aws_internet_gateway.Dharani-igw.id }"
}


#Creating Public Route Table

resource "aws_route_table" "public_route_table" {
    vpc_id = "${aws_vpc.Dharani-vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.Dharani-igw.id}" 
    }
    
    tags {
        Name = "Public Subnet Route Table"
		BuildWith = "terraform"
    }
}

# adding an elastic IP
resource "aws_eip" "elastic_ip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.Dharani-igw"]
}

# creating the NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = "${ aws_eip.elastic_ip.id }"
  subnet_id     = "${ aws_subnet.Dharani-subnet-public-1.id }"
  depends_on    = ["aws_internet_gateway.Dharani-igw"]
}

# creating private route table 
resource "aws_route_table" "private_route_table" {
  vpc_id = "${ aws_vpc.Dharani-vpc.id }"

  tags {
    Name      = "Private Subnet Route Table"
    BuildWith = "terraform"
  }
}

# adding private route table to nat
resource "aws_route" "private_route" {
  route_table_id         = "${ aws_route_table.private_route_table.id }"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${ aws_nat_gateway.nat.id }"
}

# associate subnet public to public route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = "${ aws_subnet.Dharani-subnet-public-1.id }"
  route_table_id = "${ aws_vpc.Dharani-vpc.main_route_table_id }"
}

# associate subnet private subnet to private route table
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = "${ aws_subnet.Dharani-subnet-private-1.id }"
  route_table_id = "${ aws_route_table.private_route_table.id }"
}