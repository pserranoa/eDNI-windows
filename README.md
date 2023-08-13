[![en](https://img.shields.io/badge/lang-en-green.svg)](https://github.com/pserranoa/eDNI-windows/blob/main/README.md)
[![es](https://img.shields.io/badge/lang-es-green.svg)](https://github.com/pserranoa/eDNI-windows/blob/main/README.es.md)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/pserranoa/eDNI-windows/blob/main/LICENSE.md)

# Packer, Vagrant and VirtualBox: eDNI-windows

Windows 10 and 11 with firefox, remote Spanish eDNI, card readers and Spanish signer to to be able to carry out procedures with the Spanish electronic DNI from your linux or Windows box.

## Introduction

If you need to use the e-DNI from linux or windows, you can use this vagrant image.

- [Spanish documentation](https://firmaelectronica.gob.es/Home/Ciudadanos/DNI-Electronico.html)
- [How to use your spanish DNI with NFC (spanish)](https://www.youtube.com/watch?v=z9iu5K9UWOw)

## Spanish goverment software download sites

- https://www.dnielectronico.es/PortalDNIe/
- https://firmaelectronica.gob.es/Home/Descargas.html

## Installed Software

The following software is installed on these images:

- [Firefox](https://www.mozilla.org/es-ES/firefox/new/)
- [eDNI Remote 3.0](https://www.eDNIlectronico.es/descargas/Apps/Instalador_eDNIRemote_x64.exe)
- [Card Rader for eDNI v15.0.1](https://www.eDNIlectronico.es/descargas/CSP_para_Sistemas_Windows/Windows_64_bits/Instalador_Tarjetas_eDNI_x64.exe)
- [Autofirma 1.8.2 (msi)](https://estaticos.redsara.es/comunes/autofirma/currentversion/AutoFirma64.zip)

## Adittional configurations over the images

- [x] Install virtualbox guest additions
- [x] Enable RDP
- [x] Enable WinRM
- [x] Enable powershell RemoteSigned
- [x] Enable auto login for vagrant user
- [x] Enable that the network which connects will be identified as private to enable access via powershell
- [x] Enable QuickEdit mode in the console
- [x] Enable Run command in the start menu
- [x] Show hidden files in the file explorer
- [x] Show extensions of the files in the file explorer
- [x] Show administrative tools in the start menu
- [x] Disable hibernation mode
- [x] Disable password expiration for vagrant user
- [x] Disable network configuration wizard
- [x] Disable screen saver
- [x] Updates. The images with the `-wu` suffix install the windows updates available at the time of construction.

## Configuring your computer

To create these images locally

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads). *Current image has been created with Virtualbox 7.0 on ubuntu*
2. Install [Packer](https://packer.io/downloads.html). *Current image has been created with packer 1.8.3 on ubuntu*
3. Check that both binaries are accessible in your `PATH`.
4. Install dependencies by running `packer init windows.pkr.hcl`.

## Using a pre-built image

You can use the images generated in [Vagrant Cloud](https://app.vagrantup.com/pserranoa/) with the following command:

### Windows 10

```console
vagrant init pserranoa/eDNI-windows-10_64
```

### Windows 11

```console
vagrant init pserranoa/eDNI-windows-11_64
```

Customize the `Vagrantfile` file to suit your needs. Remember that to use the Remote eDNI it is necessary that the **network is in Bridge mode**.

## Bridge mode network

The configuration for the correct use of the **remote** mode of the DNI, both the mobile device and the PC, must be on the same network. For this it is necessary to configure the network in Bridge mode, and that it can be connected to the same network as the mobile device.

```shell
config.vm.network "public_network"
```

## Vagrantfile example

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure "2" do |config|
  config.vm.box = "pserranoa/eDNI-windows-10_64"
  config.vm.guest = :windows
  config.winrm.username = "vagrant"
  config.winrm.password = "vagrant"
  config.vm.network "public_network"
  config.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp",   auto_correct: true
  config.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true

  config.vm.provider "virtualbox" do |vb|
     vb.gui = true
     vb.memory = "4096"
     vb.cpus = "2"
  end   
end
```

## Generating an image

Two files are necessary for the construction of the image:

- The template file that describes the target image.
- The variables that define current construction

Both images are built based on a single template (`windows.pkr.hcl`) and its set of variables.

## Templates currently available

- windows-10_64
- windows-10-wu_64 *(with windows updates)*
- windows-11_64
- windows-11-wu_64 *(with windows updates)*

### On Linux

```shell
./packer.sh build -var-file templates/<template_name>/vars.pkrvars.hcl windows.pkr.hcl
```

Basic commands for creating a 64-bit windows 10/11 image with the software needed to use the eDNI from Linux.

```shell
# windows 10
./packer.sh build -var-file templates/windows-10_64/vars.pkrvars.hcl windows.pkr.hcl
# windows 11
./packer.sh build -var-file templates/windows-11_64/vars.pkrvars.hcl windows.pkr.hcl
```

### On Windows

```shell
.\packer.ps1 build -var-file .\templates\<template_name>\vars.pkrvars.hcl .\windows.pkr.hcl
```

Basic commands for creating a 64-bit windows 10/11 image with the software needed to use the eDNI from Windows.

```shell
# windows 10
./packer.ps1 build -var-file .\templates\windows-10_64\vars.pkrvars.hcl .\windows.pkr.hcl
# windows 11
./packer.ps1 build -var-file .\templates\windows-11_64\vars.pkrvars.hcl .\windows.pkr.hcl
```

## ISO Images by default

| Ver | Arch | URL | md5sum |
| --- |  --- | --- | ---- |
| 10  | x64  | https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_es-es.iso | 04e5cd52bce1d59e94b9db0415d4fc8a |
| 11  | x64  | https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66751/22621.525.220925-0207.ni_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_es-es.iso | b64842e951f64a5b67b4845989dd3ab6 |

## Add the image to Vagrant

Once we generate the image within the executions under the *builds* folder, we can add it to vagrant for use. If when building it, you have used the default configuration, you will have built it with `record = "on"`, so you will have the recording of the construction of the image available.

To add the image to vagrant, you must execute the following command, in the case of having built the windows-10_64 image locally, and having used the default configuration, access the *builds/windows-10_64* folder and execute the following commands: (remember to parameterize your **Vagrantfile** file, to suit your needs. You have an example in the section [Vagrantfile example](#vagrantfile-example))

```shell
vagrant box add pserranoa/eDNI-windows-10_64 eDNI-windows-10_64_0.0.1.box
vagrant init pserranoa/eDNI-windows-10_64
vagrant up
```

```shell
vagrant box add pserranoa/eDNI-windows-11_64 eDNI-windows-11_64_0.0.1.box
vagrant init pserranoa/eDNI-windows-11_64
vagrant up
```

## Uploaded images to Vagrant Cloud

| Imagen | Version | Size | sha512sum | Date |
| ------ | ------- | ---- | --------- | ---- |
|[pserranoa/eDNI-windows-10_64](https://app.vagrantup.com/pserranoa/boxes/eDNI-windows-10_64) | **0.0.1** | 5.89 GB | 40115f6f980657fd5d0e699e67149fce5d7b768389284ea7dd26b32772987449b855505bc26c38c7fb856de1c9057ad886ea092994f6824b73e31b9827c68225 | 13/08/2023 |
|[pserranoa/eDNI-windows-11_64](https://app.vagrantup.com/pserranoa/boxes/eDNI-windows-11_64) | **0.0.1** | 6.33 GB | 4f5fe450aed37bd1e293954c88323461af412a8a509813abb257fbfcc809b8b8b340d39fd4f0b534fc0c84fbff40516ac7b4de9e15ba57e90450762ae9366c08 | 13/08/2023 |
|[pserranoa/eDNI-windows-10-wu_64](https://app.vagrantup.com/pserranoa/boxes/eDNI-windows-10-wu_64) | **0.0.1** | 11 GB | e7ae13d76c3f1400f1a8cd25ee97931dbd19853df0ca39e4cbb95559ffa1e3f92d0fcbc453efbf4d6c10e0bbada58ed47086309785429119064f69cea6817103 | 13/08/2023 |
|[pserranoa/eDNI-windows-11-wu_64](https://app.vagrantup.com/pserranoa/boxes/eDNI-windows-11-wu_64) | **0.0.1** | 11 GB | 0a645d640aa8b5b48bfe1e4a6f87f901597f935744ff73f3244c4a44d78d3b93ae03afb86ae0eab3f809564733d91339342a416b7d834d54ebd300db35f70a75 | 13/08/2023 |

## References

This repository is based on [LukeCarrier](https://github.com/LukeCarrier/packer-windows)
