variable "ami_id" {
  type = string
}

variable "sec_id" {
  type = string
}

variable "ami_key_pair_name" {
  type = string
}

variable "subnet_ids" {
  type = list(any)
}

variable "instance_type" {
  type = string
}

variable "volume_type" {
  type = string
}

variable "volume_size" {
  type = number
}

variable "zone_id" {
  type = string
}

variable "rec_name" {
  type = string
}
