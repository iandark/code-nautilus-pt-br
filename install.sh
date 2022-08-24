#!/bin/bash

# Install python-nautilus
echo "Instalando python-nautilus..."
if type "pacman" > /dev/null 2>&1
then
    # check if already install, else install
    pacman -Qi python-nautilus &> /dev/null
    if [ `echo $?` -eq 1 ]
    then
        sudo pacman -S --noconfirm python-nautilus
    else
        echo "python-nautilus já está instalado"
    fi
elif type "apt-get" > /dev/null 2>&1
then
    # Find Ubuntu python-nautilus package
    package_name="python3-nautilus"
    found_package=$(apt-cache search --names-only $package_name)
    if [ -z "$found_package" ]
    then
        package_name="python3-nautilus"
    fi

    # Check if the package needs to be installed and install it
    installed=$(apt list --installed $package_name -qq 2> /dev/null)
    if [ -z "$installed" ]
    then
        sudo apt-get install -y $package_name
    else
        echo "$package_name já está instalado."
    fi
elif type "dnf" > /dev/null 2>&1
then
    installed=`dnf list --installed nautilus-python 2> /dev/null`
    if [ -z "$installed" ]
    then
        sudo dnf install -y nautilus-python
    else
        echo "nautilus-python já está instalado."
    fi
else
    echo "Falhou em encontrar python-nautilus, por favor instale manualmente."
fi

# Remove previous version and setup folder
echo "Removendo versão anterior (se existir)..."
mkdir -p ~/.local/share/nautilus-python/extensions
rm -f ~/.local/share/nautilus-python/extensions/VSCodeExtension.py
rm -f ~/.local/share/nautilus-python/extensions/code-nautilus.py

# Download and install the extension
echo "Fazendo download da versão mais nova..."
wget --show-progress -q -O ~/.local/share/nautilus-python/extensions/code-nautilus.py https://raw.githubusercontent.com/iandark/code-nautilus-pt-br/master/code-nautilus.py

# Restart nautilus
echo "Reiniciando nautilus..."
nautilus -q

echo "Instalação finalizada"
