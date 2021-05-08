# terraform-docker-syncthing - main.tf

variable "uid" {
  type        = number
  description = "Uid for the syncthing process."
  default     = 1000
}

variable "gid" {
  type        = number
  description = "Gid for the syncthing process."
  default     = 1000
}

variable "image_version" {
  type        = string
  description = <<-DESCRIPTION
  Container image version. This module uses 'linuxserver/syncthing'.
  DESCRIPTION
  default     = "latest"
}

variable "start" {
  type        = bool
  description = "Whether to start the container or just create it."
  default     = true
}

variable "restart" {
  type        = string
  description = <<-DESCRIPTION
  The restart policy of the container. Must be one of: "no", "on-failure", "always",
  "unless-stopped".
  DESCRIPTION
  default     = "unless-stopped"
}

variable "create_config_volume" {
  type        = bool
  description = "Create a volume for the '/config' directory."
  default     = true
}

variable "config_volume_name" {
  type        = string
  description = <<-DESCRIPTION
  The name of the config volume. If empty, a name will be automatically generated like this:
  'syncthing_config_{random-uuid}'.
  DESCRIPTION
  default     = ""
}

variable "config_volume_driver" {
  type        = string
  description = "Storage driver for the config volume."
  default     = "local"
}

variable "config_volume_driver_opts" {
  type        = map(any)
  description = "Storage driver options for the config volume."
  default     = {}
}

variable "create_data_volume" {
  type        = bool
  description = "Create a volume for the '/data' directory."
  default     = true
}

variable "data_volume_name" {
  type        = string
  description = <<-DESCRIPTION
  The name of the data volume. If empty, a name will be automatically generated like this:
  'syncthing_data_{random-uuid}'.
  DESCRIPTION
  default     = ""
}

variable "data_volume_driver" {
  type        = string
  description = "Storage driver for the data volume."
  default     = "local"
}

variable "data_volume_driver_opts" {
  type        = map(any)
  description = "Storage driver options for the data volume."
  default     = {}
}

variable "container_name" {
  type        = string
  description = <<-DESCRIPTION
  The name of the syncthing container. If empty, one will be generated like this:
  'syncthing_{random-uuid}'.
  DESCRIPTION
  default     = ""
}

variable "use_ghcr" {
  type        = bool
  description = <<-DESCRIPTION
  Whether to use GitHub container registry for getting the container image instead of Docker Hub.
  DESCRIPTION
  default     = false
}

variable "labels" {
  type        = map(string)
  description = "Labels to attach to created resources that support labels."
  default     = {}
}

variable "timezone" {
  type        = string
  description = "Timezone."
  default     = "Europe/London"
}
