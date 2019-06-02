locals {
  common_tags = {
    namespace = var.namespace
    owner     = var.owner
    env       = var.env
  }
}

variable "extra_tags" {
  description = "Mapping of any extra tags you want added to resources"
  type        = map(string)
  default     = {}
}

variable "region" {
  type = string
}

variable "namespace" {
  type = string
}

variable "env" {
  type = string
}

variable "owner" {
  type = string
}

variable "logging_bucket" {
  type = string
}

