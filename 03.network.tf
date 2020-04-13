###################################
# Security Group for Bastion Server
###################################

resource "aws_security_group" "bastion-ssh" {
    name        = "bastion-ssh"
    description = "Enable Inbound and Outbound access for Bastion Server"
    vpc_id      = "${aws_vpc.Dharani-vpc.id}"
    
    # Inbound SG's
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }     
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
        ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # Outbound SG's
     egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }    
    tags {
        Name = "bastion-ssh"
    }
}

#######################################
# Security Group for Web and App Server
#######################################

  resource "aws_security_group" "Dhr-SG" {
  name        = "Dhr-SG"
  description = "Enable Inbound and Outbound access for Web and App Server"
  vpc_id      = "${aws_vpc.Dharani-vpc.id}"
 
 
  # Inbound SG's
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
   # cidr_blocks = ["10.0.1.0/24"] 
   security_groups          = ["${aws_security_group.bastion-ssh.id}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
   # cidr_blocks = ["10.0.1.0/24"]
   security_groups          = ["${aws_security_group.bastion-ssh.id}"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
   # cidr_blocks = ["10.0.1.0/24"]
   security_groups          = ["${aws_security_group.bastion-ssh.id}"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    #cidr_blocks = ["10.0.1.0/24"]
    security_groups          = ["${aws_security_group.bastion-ssh.id}"]
  }
  ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  # Outbound SG's
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Dhr-SG"
  }
}

###################################
# Security Group for DB Server
###################################

  resource "aws_security_group" "Dhr-RDS-SG" {
  name        = "Dhr-RDS-SG"
  description = "Enable Inbound and Outbound access for RDS Server"
  vpc_id      = "${aws_vpc.Dharani-vpc.id}"
 
 
  # Inbound SG's
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = ["${aws_security_group.Dhr-SG.id}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  # Outbound SG's
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Dhr-RDS-SG"
  }
}