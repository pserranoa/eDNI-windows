[![en](https://img.shields.io/badge/lang-en-green.svg)](https://github.com/pserranoa/eDNI-windows/blob/main/README.md)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/pserranoa/eDNI-windows/blob/main/LICENSE.md)

# Packer, Vagrant y VirtualBox: eDNI-windows

Windows 10 y 11 con firefox y chrome, eDNI remoto, lector de tarjetas y Autofirma para poder realizar gestiones con el DNI electrónico desde linux o windows.

## Introducción

Si necesitas utilizar desde linux o windows el e-DNI, puedes utilizar esta imagen para hacerlo.

- [Documentación en español](https://firmaelectronica.gob.es/Home/Ciudadanos/DNI-Electronico.html)
- [Video de como usar el dni con NFC](https://www.youtube.com/watch?v=z9iu5K9UWOw)

## Sites de descargas del gobierno Español

- https://www.dnielectronico.es/PortalDNIe/
- https://firmaelectronica.gob.es/Home/Descargas.html

## Software instalado

Estas imagenes tienen instalado el siguiente software:

- [Navegador Firefox](https://www.mozilla.org/es-ES/firefox/new/)
- [Navegador Chrome](https://www.mozilla.org/es-ES/firefox/new/)
- [eDNI Remote 3.0](https://www.eDNIlectronico.es/descargas/Apps/Instalador_eDNIRemote_x64.exe)
- [Instalador tarjetatas eDNI v15.0.1](https://www.eDNIlectronico.es/descargas/CSP_para_Sistemas_Windows/Windows_64_bits/Instalador_Tarjetas_eDNI_x64.exe)
- [Autofirma version 1.8.2 (msi)](https://estaticos.redsara.es/comunes/autofirma/currentversion/AutoFirma64.zip)

## Configuraciones adicionales sobre las imagenes

- [x] Instalación de herramienas de intragración de virtualbox. (Guest Additions)
- [x] Habilitar el acceso remoto via RDP. (Escritorio remoto)
- [x] Habilitar el acceso remoto via WinRM
- [x] Habilitar powershell RemoteSigned
- [x] Habilitar el auto login del usuario vagrant
- [x] Habilitar que red a la que se conecta se identifique como privada para permitir el acceso via powershell
- [x] Habilitar el modo QuickEdit en la consola
- [x] Habilitar el comando Run en el menu de inicio
- [x] Mostrar ficheros ocultos en el explorador de ficheros
- [x] Mostrar extensiones de los ficheros en el explorardor de ficheros
- [x] Mostrar las herramientas administrativas en el menu de inicio
- [x] Deshabilitar el modo hibernación
- [x] Deshabilitar la expiración de la contraseña del usuario vagrant
- [x] Deshabilitar el wizard de configuración de red
- [x] Deshabilitar el protector de pantalla
- [x] Actualizaciones. Las imagenes con el sufijo `-wu` instalan las actualizaciones de windows disponibles en el momento de construcción.

## Configurando tu equipo

Para crear estas imagenes en local

1. Instale [VirtualBox](https://www.virtualbox.org/wiki/Downloads). *La imagen actual ha sido creada con Virtualbox 7.0 sobre ubuntu*
2. Instale [Packer](https://packer.io/downloads.html). *La imagen actual ha sido creada con packer 1.8.3 sobre ubuntu*
3. Asegurese que ambos binarios estan accesibles en su `PATH`.
4. Instale las dependencias ejecutando `packer init windows.pkr.hcl`.

## Utilizando imagen previamente generado

Puedes utilizar la imagenes generadas en [Vagrant Cloud](https://app.vagrantup.com/pserranoa/) con el siguiente comando:

### Windows 10

```console
vagrant init pserranoa/eDNI-windows-10_64
```

### Windows 11

```console
vagrant init pserranoa/eDNI-windows-11_64
```

customiza el fichero `Vagrantfile` para que se ajuste a tus necesidades. Recuerda que para hacer uso del Remote eDNI es necesario que la **red este en modo Bridge**.

## Red en modo "Bridge"

La configuración para la correcta utilizacion del modo **remoto** del DNI, tanto el dispositivo movil como el PC, deben estar en la misma red. Para ello es necesario configurar la red en modo Bridge, y que pueda estar conectado a la misma red que el dispositivo movil.

```shell
config.vm.network "public_network"
```

## Ejemplo de Vagrantfile

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

## Generando una imagen

Dos ficheros son necesarios para la construcción de la imagen:

- El fichero de plantilla que describe la imagen de destino.
- Las variables que definen dicha construccion

Ambas imagenes son construidas en base a una unica plantilla (`windows.pkr.hcl`) y su conjuto de variables.

## Plantillas actualmente disponibles

- windows-10_64
- windows-10-wu_64 *(with windows updates)*
- windows-11_64
- windows-11-wu_64 *(with windows updates)*

### En Linux

```shell
./packer.sh build -var-file templates/<template_name>/vars.pkrvars.hcl windows.pkr.hcl
```

Comandos básicos para la creación de una imagen de windows 10/11 64 bits con el software necesario para el uso del eDNI desde Linux.

```shell
# windows 10
./packer.sh build -var-file templates/windows-10_64/vars.pkrvars.hcl windows.pkr.hcl
# windows 11
./packer.sh build -var-file templates/windows-11_64/vars.pkrvars.hcl windows.pkr.hcl
```

### En Windows

```shell
.\packer.ps1 build -var-file .\templates\<template_name>\vars.pkrvars.hcl .\windows.pkr.hcl
```

Comandos básicos para la creación de una imagen de windows 10/11 64 bits con el software necesario para el uso del eDNI desde Windows.

```shell
# windows 10
./packer.ps1 build -var-file .\templates\windows-10_64\vars.pkrvars.hcl .\windows.pkr.hcl
# windows 11
./packer.ps1 build -var-file .\templates\windows-11_64\vars.pkrvars.hcl .\windows.pkr.hcl
```

## Imagenes ISO por defecto

| Ver | Arch | URL | md5sum |
| --- |  --- | --- | ---- |
| 10  | x64  | https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_es-es.iso | 04e5cd52bce1d59e94b9db0415d4fc8a |
| 11  | x64  | https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66751/22621.525.220925-0207.ni_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_es-es.iso | b64842e951f64a5b67b4845989dd3ab6 |

## Añadir la imagen a Vagrant

Una vez que generamos la imagen dentro de las ejecuciones bajo la carpeta *builds* la podemos añadir a vagrant para su utilización. Si al construirla, has utilizado la configuración por defecto, la habrás construido con `record = "on"`, con lo que tendras disponible la grabación de la construccion de la imagen.

Para añadir la imagen a vagrant, debes ejecutar el siguiente comando, en el caso de haber construido en local la imagen de windows-10_64, y haber utilizado la configuración por defecto, accede a la carpeta *builds/windows-10_64* y ejecuta los siguiente comandos: (recuerda parametrizar tu fichero de **Vagrantfile**, para que se ajuste a tus necesidades. Tienes un ejemplo en la sección [Ejemplo de Vagrantfile](#ejemplo-de-vagrantfile))

```shell
vagrant box add pserranoa/eDNI-windows-10_64 eDNI-windows-10_64_<version>.box
vagrant init pserranoa/eDNI-windows-10_64
vagrant up
```

```shell
vagrant box add pserranoa/eDNI-windows-11_64 eDNI-windows-11_64_<version>.box
vagrant init pserranoa/eDNI-windows-11_64
vagrant up
```

## Imagenes subidas a Vagrant Cloud

| Imagen | Version | Size | sha512sum | Date |
| ------ | ------- | ---- | --------- | ---- |
|[pserranoa/eDNI-windows-10_64](https://app.vagrantup.com/pserranoa/boxes/eDNI-windows-10_64) | **0.0.2** | 6.3 GB | f22d2beae8cc2fc458d7f935156b27aeebf74dae0c61abe9b551cc29b4274195c1b39903626b6189e72d10d23d34ba69f33c4b62def9e622fa258603363714dc | 02/10/2023 |
|[pserranoa/eDNI-windows-11_64](https://app.vagrantup.com/pserranoa/boxes/eDNI-windows-11_64) | **0.0.2** | 6.5 GB | a3a6687fcd81bca365cc4e97c1f56854db9606fc6ca94f5c81de60df7e8e5135ee7791bf77cf9c1dd22b5d47f752da979e992aa6013460cce1e1dc9a2fe17e49 | 02/10/2023 |
|[pserranoa/eDNI-windows-10-wu_64](https://app.vagrantup.com/pserranoa/boxes/eDNI-windows-10-wu_64) | **0.0.2** | 12 GB | bf1d64dab7a1f678a3288ea959b1efc8d6e908ac445e40ddb941a87a8b8634d2aee9596be61db579e0b84f09da1604b83f807e4a5e37b30fe788c1def36f1e88 | 02/10/2023 |
|[pserranoa/eDNI-windows-11-wu_64](https://app.vagrantup.com/pserranoa/boxes/eDNI-windows-11-wu_64) | **0.0.2** | 12 GB | 0a3c97e3b565c35f4a629a4d0c30b720906056f49b4d41801cd1488ea4edc2ee15f512b1eee9c386bde42dc6d7f2f86851ee08257d758a86c650c10106c50b97 | 02/10/2023 |

## Referencias

Repositorio basado en [LukeCarrier](https://github.com/LukeCarrier/packer-windows)