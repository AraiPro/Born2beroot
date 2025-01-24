  GNU nano 7.2                                                                                     monitoring.sh                                                                                              
#!/bin/bash

#set -x  # Habilita el modo de depuración

export TERM=dumb

# Número total de caracteres de la línea de almohadillas
line_width=79  # Ajusta este valor si la línea de almohadillas tiene un tamaño diferente

# Obtener el ancho del sistema (el resultado de `uname -a`)
system_info=$(uname -a)

# Recortar el resultado de `uname -a` para que encaje dentro del ancho
adjusted_info1=$(echo "$system_info" | cut -c1-$((line_width -17)))  # Ajusta para encajar
adjusted_info2=$(echo "$system_info" | cut -c$((line_width -17))-)   # Lo que sobra

echo -e "\n\033[38;5;213m########################################################################\033[0m"

#architecture of the system & kernel
echo -e "       \x1B[35mArchitecture: \x1B[0m"
# Imprimir la arquitectura ajustada dentro del ancho
echo "  $adjusted_info1"
# Si hay texto adicional, imprimirlo en la siguiente línea
if [ -n "       $adjusted_info2" ]; then
    echo "      $adjusted_info2"
fi

#CPU PHYSICAL
echo -e "       \033[35mCPU Physical:\033[0m$(inxi --color 0 -C | grep 'Info: ' | sed 's/  Info *.//' | sed 's/ model.*//')"

#CPU VIRTUAL
echo -e "       \033[35mCPU Virtual: \033[0m$(nproc)"

#RAM
echo -e "       \x1B[35mRAM: \x1B[0m$(inxi --color 0 -m | grep 'RAM' | sed 's/ *RAM: //' | sed '/RAM Report/d')"

#STORAGE
echo -e "       \x1B[35mLocal Storage: \x1B[0m$(inxi --color 0 -d | grep 'Storage' | sed 's/[[:space:]]*Local Storage: //' | sed 's/  ID.*//')"

#CPU LOAD
/home/acoronad/cpu_usage.sh

#LAST BOOT
echo -e "       \033[35mLast boot: \033[0m$(who -b | awk '{print $(NF-1), $NF}')"

#LVM USE
echo -e "       \033[35mLVM use: \033[0m$(lsblk | grep 'lvm' > /dev/null && echo 'yes' || echo 'no')"

#TCP CONNECTIONS
echo -e "       \033[35mTPC Connections: \033[0m$(ss -tn | grep ESTAB | wc -l)"

#USERS LOG
echo -e "       \033[35mUser log: \033[0m$(users | wc -l)"

#NETWORK IP + MAC
if [ -z "       $(hostname -I)" ]; then
    echo -e "   \033[35mIP: \033[0mNo se detectó ninguna IP activa \033[35mMAC: \033[0m$(inxi --color 0 --no-filter -n | grep 'mac' | awk '{print $NF}')"
else
    echo -e "   \033[35mIP: \033[0m$(hostname -I)  \033[35mMAC: \033[0m$(inxi --color 0 --no-filter -n | grep 'mac' | awk '{print $NF}')"
fi

#SUDO ORDERS
# Count journalctl entries
#echo -e "      \033[35mSudo: \033[0m$(journalctl _COMM=sudo -q | grep COMMAND | wc -l) cmd"
echo -e "       \033[35mSudo: \033[0m$(grep COMMAND ../../var/log/sudo/registro.log | wc -l) cmd"
echo -e "\033[38;5;213m########################################################################\033[0m\n"
