// This template creates the following resources
// - An RDS instance
// - A database subnet group

####################
# DB Subnet Group
####################
resource "aws_db_subnet_group" "dhr-subgrp" {
    name            = "dhr-subnetgrp"
    description     = "RDS Subnet Group"
    subnet_ids      = ["${aws_subnet.Dharani-subnet-private-1.id}","${aws_subnet.Dharani-subnet-private-2.id}"]
    tags = {
    Name = "dhr-subgrp"
  }
}

#####################
# DB Parameter Group
#####################
resource "aws_db_parameter_group" "dhr-pargrp" {
    name           = "dhr-pargrp"
    family         = "mysql5.5"

    parameter {
      name    = "collation_server"
      value   = "utf8_general_ci"
   }
    parameter {
      name    = "character_set_client"
      value   = "utf8"
   }
    parameter {
      name    = "character_set_connection"
      value   = "utf8"
   }
    parameter {
      name    = "character_set_database"
      value   = "utf8"
   }
    parameter {
      name    = "character_set_server"
      value   = "utf8"
   }
    parameter {
      name    = "innodb_file_format"
      value   = "Antelope"
   }
    parameter {
      name    = "collation_connection"
      value   = "utf8_general_ci"
   }
    parameter {
      name    = "max_allowed_packet"
      value   = "33554432"
   }
    parameter {
      name    = "max_connections"
      value   = "200"
   }  
    parameter {
      name    = "innodb_file_per_table"
      value   = "1"
   }
}

###############
# RDS Instance
###############
 resource "aws_db_instance" "dhr-mysqlrds" {
    identifier                      = "dhr-mysqlrds"
    instance_class                  = "${var.dhr_rds_instclass}"
    #availability_zones        = ["us-east-1a,us-east-1b"]
    storage_encrypted               = "${var.dhr_rds_storageencrypted}"	    	
    allocated_storage               = "${var.dhr_rds_allocated_storage}"   
    engine                          = "${var.dhr_rds_engine}"
    engine_version                  = "${var.dhr_rds_engineversion}"   
    name                            = "${var.dhr_rds_name}"
    username                        = "${var.dhr_rds_dbusername}"
    password                        = "${var.dhr_rds_dbpassword}"
    tags 
	    {
            Name                    = "dhr-mysqlrds"
        }
	  
    # Because we're assuming a VPC, we use this option, but only one SG id
        vpc_security_group_ids      = ["${aws_security_group.Dhr-SG.id}"]
       # security_groups          = ["${aws_security_group.Dhr-RDS-SG.id}"]

    # We're creating a subnet group in the module and passing in the name
        db_subnet_group_name        = "${aws_db_subnet_group.dhr-subgrp.id}"
        parameter_group_name        = "${aws_db_parameter_group.dhr-pargrp.name}"

    # We want the multi-az setting to be toggleable, but off by default
        multi_az                    = "${var.dhr_rds_multiaz}"
        storage_type                = "${var.dhr_rds_storage_type}"
        iops                        = "${var.dhr_rds_iops}"
        publicly_accessible         = "${var.dhr_rds_publiclyaccessible}"

    # Upgrades
    #    allow_major_version_upgrade = "${var.dhr_rds_allowmajorversionupgrade}"
     #   auto_minor_version_upgrade  = "${var.dhr_rds_autominorversionupgrade}"
      #  apply_immediately           = "${var.dhr_rds_applyimmediately}"
        #maintenance_window         = "${var.dhr_rds_maintenancewindow}"

    # Snapshots and backups
        skip_final_snapshot         = "${var.dhr_rds_skipfinalsnapshot}"
        copy_tags_to_snapshot       = "${var.dhr_rds_copytagstosnapshot}"

      #  backup_retention_period     = "${var.dhr_rds_backupretentionperiod}"
        #backup_window              = "${var.dhr_rds_backupwindow}"

    # enhanced monitoring
     #   monitoring_interval         = "${var.dhr_rds_monitoringinterval}"
}