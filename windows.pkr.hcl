packer {
}

variable "build_dir" {
  type    = string
  default = env("PACKER_BUILD_DIR")
}

variable "template" {
  type = string
}

variable "version" {
  type = string
}

variable "guest_os_type" {
  type = string
}

variable "iso_url" {
  type = string
}

variable "iso_checksum" {
  type = string
}

variable "record" {
  type    = string
  default = "off"
}

locals {
  cpus      = 2
  memory_mb = 4096
  disk_size = 8000

  communicator = {
    communicator   = "winrm"
    winrm_timeout  = "10h"
    winrm_username = "vagrant"
    winrm_password = "vagrant"
  }

  cd_files = [
    "../../templates/${var.template}/Autounattend.xml",
    "../../scripts/config/fixnetwork.ps1",
    "../../scripts/config/disable-screensaver.ps1",
    "../../scripts/config/disable-winrm.ps1",
    "../../scripts/config/enable-winrm.ps1",
    "../../scripts/config/win-updates.ps1",
    "../../scripts/config/enable-rdp.ps1",
    "../../scripts/config/virtualbox-tools.ps1",
    "../../scripts/eDNI/firefox.ps1",
    "../../scripts/eDNI/AutoFirma.ps1",
    "../../scripts/eDNI/DNIeRemote.ps1",
    "../../scripts/eDNI/Tarjetas_DNIe.ps1",
  ]

  shutdown = {
    command = "shutdown /s /t 5 /f /d p:4:1 /c \"Packer Shutdown\""
    timeout = "30m"
  }
}

source "virtualbox-iso" "edni_windows" {
  vm_name = var.template

  format        = "ova"
  guest_os_type = var.guest_os_type
  headless      = true

  firmware             = "efi"
  guest_additions_mode = "disable"

  vboxmanage = [
    [
      "modifyvm", "{{ .Name }}",
      "--memory", local.memory_mb,
      "--cpus",   local.cpus,
      "--firmware", "efi",
    ],
    [
      "modifyvm",            "{{ .Name }}",
      "--recordingscreens",  "0",
      "--recordingvideores", "1024x768",
      "--recordingvideorate", "512",
      "--recordingvideofps", "25",
      "--recordingfile",     "${var.build_dir}/capture.webm",
      "--recordingopts",     "vc_enabled=true,ac_enabled=true,ac_profile=med",
      "--recording",         "${var.record}",
    ],
  ]
  vboxmanage_post = [
    [
      "modifyvm",    "{{ .Name }}",
      "--recording", "off",
    ],
  ]

  hard_drive_interface = "sata"
  iso_interface        = "sata"
  iso_url              = var.iso_url
  iso_checksum         = "md5:${var.iso_checksum}"

  boot_command = ["a<wait>a<wait>a"]
  boot_wait = "-1s"

  communicator   = local.communicator.communicator
  winrm_timeout  = local.communicator.winrm_timeout
  winrm_username = local.communicator.winrm_username
  winrm_password = local.communicator.winrm_password

  cd_files = local.cd_files

  shutdown_command = local.shutdown.command
  shutdown_timeout = local.shutdown.timeout
}

build {
  sources = [
    "source.virtualbox-iso.edni_windows",
  ]

  post-processor "vagrant" {
    output               = "eDNI-${var.template}_${var.version}.box"
    vagrantfile_template = "../../templates/${var.template}/vagrantfile.template"
  }
}
