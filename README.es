Lo que encontrarás en este repositorio es una guía complementaria para la realización del proyecto Born2beroot de 42.

Se trata de una guía complementaria, orientada a que enfrentar la evaluación.
Aquí encontarás resumenes de todos los aspectos generales del proyecto, y te darán una idea asequible de qué es cada cosa.
Pero esto no es más que una iniciación, lo suficiente como para poder aprobar el proyecto y una pequeña base sobre la que poder ir construyendo.

La guía comienza depués de que te hayas descargado la última versión estable de [Debian:
](https://www.debian.org/distrib/index.es.html)
Lo primero que debes saber es cual es la arquitectura de tu ordenador para saber cual descargar. Para la instalación te recomiendo que utilices una de las muchas
guías que ya existen, en la que te explicarán paso a paso como configurar tu máquina virtual e instalar Debian sin entorno gráfico y cómo crear las particiones,
los volúmenes lógicos y cómo encriptarlos.

Esa parte está ya muy cubierta por las guías que han subido los compañeros, donde veo que faltaba mas información era en la parte teórica y en la explicación de
los comandos, y en donde y como hayar la información que necesitas dentro del sistema.
Aquí encontrarás los comandos explicados, la estructura de archivos de Debian, y cómo calcular los procesos que no devuelve el sistema en sus programas básicos.

Para todo esto debes descargarte, si no lo tienes ya en tu sistema:

sudo (para gestiones de súper usuario)
apt install sudo

ufw (para la gestión de los puertos)
apt install ufw

shh (para permitir conexiones en tu máquina)
apt install openssh-server

cron (para temporizar el script)
apt install cron

pwquality (para la gestión de contraseñas)
sudo apt install libpwquality-tools

Una vez tengas todos estos programas estarás listo/a para empezar a probar comandos y a administrar tu máquina Debian!!
