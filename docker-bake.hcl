### File: docker-bake.hcl
##
## anki-card-cliのDockerイメージを組み立てる。
##
## Usage:
##
## ------ Text ------
## docker buildx bake -f docker-bake.hcl
## ------------------
##
## Env variable:
##
##   IMG_AUTHORS - org.opencontainers.image.authorsの値。
##   IMG_CREATED - org.opencontainers.image.createdの値。
##   IMG_DESC - org.opencontainers.image.descの値。
##   IMG_LICENSE- org.opencontainers.image.licenseの値。
##   IMG_TITLE - org.opencontainers.image.titleの値。
##   IMG_URL - org.opencontainers.image.urlの値。
##   IMG_VER - org.opencontainers.image.versionの値。
##
## Metadata:
##
##   id - 560dc18d-7294-49e3-87f8-af98890274b6
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.0
##   created - 2026-01-05
##   modified - 2026-01-05
##   copyright - Copyright (C) 2026-2026 qq542vev. All rights reserved.
##   license - <AGPL-3.0-only at https://www.gnu.org/licenses/agpl-3.0.txt>
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/anki-card-cli>
##   * <Bag report at https://github.com/qq542vev/anki-card-cli/issues>

variable "IMG_AUTHS" {}
variable "IMG_CREATED" {default = timestamp()}
variable "IMG_DESC" {}
variable "IMG_LICENSE" {}
variable "IMG_TITLE" {}
variable "IMG_URL" {}
variable "IMG_VER" {}
variable "labels" {
  default = {
    "org.opencontainers.image.created" = IMG_CREATED
    "org.opencontainers.image.authors" = IMG_AUTHS
    "org.opencontainers.image.url" = IMG_URL
    "org.opencontainers.image.version" = IMG_VER
    "org.opencontainers.image.license" = IMG_LICENSE
    "org.opencontainers.image.title" = IMG_TITLE
    "org.opencontainers.image.description" = IMG_DESC
  }
}
variable "tags" {
  default = [
    "ghcr.io/qq542vev/anki-card-cli:${IMG_VER}",
    "registry.gitlab.com/qq542vev/anki-card-cli:${IMG_VER}"
  ]
}

group "default" {
  targets = ["nofonts", "corefonts", "allfonts"]
}

target "common" {
  context = "."
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm64/v8", "linux/ppc64le"]
  labels = labels
  annotations = formatlist("%s=%s", keys(labels), values(labels))
  output = ["type=registry"]
}

target "nofonts" {
  inherits = ["common"]
  tags = formatlist("%s-%s", tags, "nofonts")
}

target "corefonts" {
  inherits = ["common"]
  args = {
    FONTS = "fonts-noto-cjk fonts-noto-color-emoji fonts-noto-core fonts-noto-mono"
  }
  tags = formatlist("%s-%s", tags, "corefonts")
}

target "allfonts" {
  inherits = ["common"]
  args = {
    FONTS = "fonts-noto-cjk fonts-noto-color-emoji fonts-noto-core fonts-noto-mono fonts-noto-cjk-extra fonts-noto-extra"
  }
  tags = formatlist("%s-%s", tags, "allfonts")
}
