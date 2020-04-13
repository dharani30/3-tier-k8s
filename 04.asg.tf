// This template creates the following resources
// - An Launch config for master and worker nodes
// - A AutoScaling group for  master and worker nodes


#Creating Ec2 Bastion instance in Public Subnet

resource "aws_instance" "Bastion" {
    ami                      = "${var.dhr_amiid}"
    instance_type            = "${var.dhr_insttype}"
    subnet_id                = "${aws_subnet.Dharani-subnet-public-1.id}"
    vpc_security_group_ids   = ["${aws_security_group.bastion-ssh.id}"]
    key_name                 = "${var.dhr_keyname}"
    associate_public_ip_address = "true"
    user_data = <<-EOF
              #!/bin/bash
              sudo apt-get -y update
              EOF
    tags {
        BuiltWith = "terraform"
        Name      = "Bastion"
    }
}

####################################
#Launch configuration of Master Node
####################################

resource "aws_launch_configuration" "Dhr-LaunchConfig-MasterNode" {
  name                     = "Dhr-LaunchConfig-MasterNode"
  image_id                 = "${var.dhr_amiid}"
  instance_type            = "${var.dhr_insttype}"
  key_name                 = "${var.dhr_keyname}"
  security_groups          = ["${aws_security_group.Dhr-SG.id}"]
  user_data = <<-EOF
              #Install the base image
              sudo apt-get -y  update
              EOF
 lifecycle 
   {
    create_before_destroy  = true
   }

}

##################################
# Autoscaling group for MasterNode
##################################

resource "aws_autoscaling_group" "Dhr-ASG-master" {
  name                      = "Dhr-ASG-master"
  vpc_zone_identifier       = ["${aws_subnet.Dharani-subnet-private-1.id}"]
  #availability_zones       = ["us-east-1a,us-east-1b"]
  launch_configuration      = "${aws_launch_configuration.Dhr-LaunchConfig-MasterNode.id}"
  min_size                  = "${var.dhr_minsize}"
  max_size                  = "${var.dhr_maxsize}"
  desired_capacity          = "${var.dhr_desiredcap}"
  health_check_grace_period = "${var.dhr_healthcheckperiod}"
  health_check_type         = "${var.dhr_healthchecktype}"
  #default_cooldown         = "10"
  lifecycle 
   {
    create_before_destroy   = true
   }
   tag {
    key                 = "Name"
    value               = "Dharani-Master-Node"
    propagate_at_launch = true
  }
}

####################################
#Launch configuration of Worker Node
####################################

resource "aws_launch_configuration" "Dhr-LaunchConfig-Worker" {
  name                     = "Dhr-LaunchConfig-Worker"
  image_id                 = "${var.dhr_amiid}"
  instance_type            = "${var.dhr_insttype}"
  key_name                 = "${var.dhr_keyname}"
  security_groups          = ["${aws_security_group.Dhr-SG.id}"]
  user_data = <<-EOF
              #Install the base image
              sudo apt-get -y  update
              EOF
  lifecycle 
   {
    create_before_destroy  = true
   }
   

}

##################################
# Autoscaling group for Worker Node
##################################

resource "aws_autoscaling_group" "Dhr-ASG-worker" {
  name                      = "Dhr-ASG-worker"
  vpc_zone_identifier       = ["${aws_subnet.Dharani-subnet-private-1.id}"]
  #availability_zones        = ["us-east-1a,us-east-1b"]
  launch_configuration      = "${aws_launch_configuration.Dhr-LaunchConfig-Worker.id}"
  min_size                  = "${var.dhr_minsize}"
  max_size                  = "${var.dhr_maxsize}"
  desired_capacity          = "${var.dhr_desiredcap}"
  health_check_grace_period = "${var.dhr_healthcheckperiod}"
  health_check_type         = "${var.dhr_healthchecktype}"
  #default_cooldown         = "10"
  lifecycle 
   {
    create_before_destroy   = true
   }
   tag {
    key                 = "Name"
    value               = "Dharani-Worker-node"
    propagate_at_launch = true
  }
}

