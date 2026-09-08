variable "aws_region" {
  description = "AWS region where instances will be created"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Prefix used to name/tag resources"
  type        = string
  default     = "myproject"
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "EC2 instance type. Free Tier eligibility depends on account age: accounts created before July 2021 get t2.micro free; accounts created after that get t3.micro free instead."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name for SSH access (leave blank to skip)"
  type        = string
  default     = ""
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB (Free Tier covers up to 30GB)"
  type        = number
  default     = 8
}
