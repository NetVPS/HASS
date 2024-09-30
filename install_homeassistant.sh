#!/bin/bash

# Actualizar los paquetes de Termux
pkg update -y
pkg upgrade -y

# Instalar dependencias necesarias, incluyendo CMake y Ninja desde los repositorios de Termux
pkg install -y python libffi openssl clang make libjpeg-turbo zlib bzip2 libsqlite readline git rust openssh binutils-is-llvm cmake ninja

# Comprobar si binutils se instaló correctamente
if ! command -v aarch64-linux-android-ar &> /dev/null
then
    echo "Error: La herramienta aarch64-linux-android-ar no se instaló correctamente."
    exit 1
fi

# Configurar SSH y establecer una contraseña
echo "Instalando y configurando SSH"
sshd

# Establecer contraseña para el usuario actual
echo "Por favor, introduce una contraseña para el acceso SSH:"
passwd

# Verificar que SSH está corriendo
echo "Comprobando el estado del servicio SSH..."
pgrep sshd > /dev/null && echo "SSH está en ejecución" || echo "SSH no está ejecutándose"

# Crear un entorno virtual para Home Assistant
echo "Creando entorno virtual para Home Assistant"
python -m venv homeassistant

# Activar el entorno virtual
echo "Activando entorno virtual"
source homeassistant/bin/activate

# Configurar PKG_CONFIG_PATH
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

# Actualizar pip e instalar wheel, tzdata, Home Assistant y numpy
echo "Actualizando pip e instalando wheel, tzdata, Home Assistant, y numpy"
pip install --upgrade pip
pip install wheel tzdata homeassistant numpy

# Iniciar Home Assistant
echo "Iniciando Home Assistant..."
hass
