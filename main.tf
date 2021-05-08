# terraform-docker-syncthing - main.tf

resource "random_uuid" "this" {}

data "docker_registry_image" "this" {
  name = "%{ if var.use_ghcr }ghcr.io/%{ endif }linuxserver/syncthing:${var.image_version}"
}

resource "docker_image" "this" {
  name          = data.docker_registry_image.this.name
  pull_triggers = [data.docker_registry_image.this.sha256_digest]
}

resource "docker_volume" "config" {
  count = var.create_config_volume ? 1 : 0

  name        = local.config_volume_name
  driver      = var.config_volume_driver
  driver_opts = var.config_volume_driver_opts

  dynamic "labels" {
    for_each = var.labels
    iterator = label
    content {
      label = label.key
      value = label.value
    }
  }
}

resource "docker_volume" "data" {
  count = var.create_data_volume ? 1 : 0

  name        = local.data_volume_name
  driver      = var.data_volume_driver
  driver_opts = var.data_volume_driver_opts

  dynamic "labels" {
    for_each = var.labels
    iterator = label
    content {
      label = label.key
      value = label.value
    }
  }
}

resource "docker_container" "this" {
  name  = local.container_name
  image = docker_image.this.latest

  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=${var.timezone}",
  ]

  ports {
    internal = 8384
    external = 8384
    protocol = "tcp"
  }

  ports {
    internal = 22000
    external = 22000
    protocol = "tcp"
  }

  ports {
    internal = 21027
    external = 21027
    protocol = "udp"
  }

  # config volume
  dynamic "volumes" {
    for_each = docker_volume.config
    iterator = volume
    content {
      volume_name    = volume.value.name
      container_path = "/config"
    }
  }

  # data volume
  dynamic "volumes" {
    for_each = docker_volume.data
    iterator = volume
    content {
      volume_name    = volume.value.name
      container_path = "/data"
    }
  }

  dynamic "labels" {
    for_each = var.labels
    iterator = label
    content {
      label = label.key
      value = label.value
    }
  }

  must_run = true
  restart  = var.restart
  start    = var.start
}

locals {
  config_volume_name = var.create_config_volume ? (
    var.config_volume_name != "" ? var.config_volume_name : (
      "syncthing_config_${random_uuid.this.result}"
    )
  ) : ""

  data_volume_name = var.create_data_volume ? (
    var.data_volume_name != "" ? var.data_volume_name : (
      "syncthing_data_${random_uuid.this.result}"
    )
  ) : ""

  container_name = var.container_name != "" ? var.container_name : (
    "syncthing_${random_uuid.this.result}"
  )
}
