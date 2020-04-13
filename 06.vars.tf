variable "dhr_amiid" {
 
    default = "ami-07ebfd5b3428b6f4d"

}

# name of the key to be used
variable "dhr_keyname" {
  default = "2020key"
}

##############
# EC2 Instances
##############
variable "dhr_insttype" {
  description = "The size of instance to launch"
  default = "t2.micro"
}

variable "dhr_maxsize" {
  description = "The maximum size of the auto scale group"
  default = "1"
}

variable "dhr_minsize" {
  description = "The minimum size of the auto scale group"
  default = "1"
}

variable "dhr_desiredcap" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  default = "1"
}

variable "dhr_healthcheckperiod" {
  description = "Time (in seconds) after instance comes into service before checking health"
  default     = "300"
}

variable "dhr_healthchecktype" {
  description = "Controls how health checking is done. Values are - EC2 and ELB"
  default = "EC2"
}

###########
# RDS MYSQL
###########

variable "dhr_rds_dbusername" {
  description = "Username for the master DB user"
  default = "dharanirds"
}

variable "dhr_rds_dbpassword" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  default = "dharanirds"
}

variable "dhr_rds_allocated_storage" {
  description = "The allocated storage in gigabytes"
  default = "20"
}

variable "dhr_rds_storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'."
  default     = "gp2"
}

variable "dhr_rds_storageencrypted" {
  description = "Specifies whether the DB instance is encrypted"
  default     = "false"
}

variable "dhr_rds_engine" {
  description = "The database engine to use"
  default = "mysql"
}

variable "dhr_rds_engineversion" {
  description = "The engine version to use"
  default = "5.5.57"
}

variable "dhr_rds_instclass" {
  description = "The instance type of the RDS instance"
  default = "db.t2.small"
}

variable "dhr_rds_name" {
  description = "The DB name to create. If omitted, no database is created initially"
  default     = "dharanirds"
}

variable "dhr_rds_multiaz" {
  description = "Specifies if the RDS instance is multi-AZ"
  default     = "false"
}

variable "dhr_rds_iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
  default     = "0"
}

variable "dhr_rds_publiclyaccessible" {
  description = "Bool to control if instance is publicly accessible"
  default     = false
}

variable "dhr_rds_skipfinalsnapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  default     = "true"
}

variable "dhr_rds_copytagstosnapshot" {
  description = "On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)"
  default     = "false"
}