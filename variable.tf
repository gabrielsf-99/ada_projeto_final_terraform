variable "cidr_vpc" {
  description = "CIDR da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "allocated_storage"{
  description = "Allocated storage for the RDS"
  type        = number
  default     = 400
}

variable "iops"{
  description = "Master password for the RDS"
  type        = number
  default     = 1000
}