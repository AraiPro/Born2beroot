#!/bin/bash

# Lectura inicial
read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
cpu_total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
cpu_idle1=$((idle + iowait))

# Espera un segundo
sleep 1

# Segunda lectura
read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
cpu_total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
cpu_idle2=$((idle + iowait))

# Cálculo de diferencia y porcentaje de uso
cpu_total_diff=$((cpu_total2 - cpu_total1))
cpu_idle_diff=$((cpu_idle2 - cpu_idle1))

# Evitar división por cero (-ne quiere decir not equal, es decir que no es igual)
if [ $cpu_total_diff -ne 0 ]; then
    cpu_usage=$((100 * (cpu_total_diff - cpu_idle_diff) / cpu_total_diff))
else
    cpu_usage=0

# Pone fin al script
fi

# Mostrar resultados
echo -e "       \033[35mCPU Load: \033[0m$cpu_usage%"


#########################    Explicación del script    ###############################

#Este script calcula el porcentaje de uso de la CPU comparando dos lecturas de /proc/stat
#La línea cpu  contiene la información sobre el uso de la CPU.
#Las variables cpu_total1 y cpu_idle1 calculan el total de tiempo de CPU y el tiempo inactivo
#de la CPU respectivamente, sumando diferentes valores.
#Se calcula el porcentaje de la CPU utilizada como la diferencia entre el tiempo total de la
#CPU y el tiempo inactivo, dividida entre el tiempo total de la CPU.
#Finalmente, imprime el porcentaje de uso de la CPU.

#PROCESO PASO A PASO:

#Hacemos una lectura inicial (read) del documento /proc/stat que es en el que
# se va volcando la info del uso del procesador.
#El archivo /proc/stat es parte del sistema de archivos virtual /proc, que
# proporciona información sobre el estado del sistema y la actividad del kernel en Linux.
#Concretamente lo que vuelca son una serie de metricas sobre el rendimiedno que corresponden
# a cpu, user, nice, system, idle, iowait, irq, softirq, steal y guest, pero estos nombres
# son enrealidad variables que acumulan dicha info, es decir, podríamos poner otros.
#Lo que le estamos pidiendo es que lea una vez las metricas de estos apartados,
# que los sume y los guarde en dos variables: la primera variable guarda la suma de los momentos
# de actividad y la segunda de los momentos de incatividad.
#Después le mandamos sleep que es para que espere y la cantidad de 1 segundo y luego que vuelva
# a tomar los datos, de tal manera que podemos obtener una media del uso del procesador de dos valores
# con diferencia de un segundo y devolver un valor que contempla el uso del procesador en un marco de
# 1 segundo, esto es específico de este script, podría haber sacado el porcentaje de una única lectura,
# pero he comprobado que entre una lectura y la siguiente puede variar muchísimo así que me parecía más
# fiable hacer una media.


#Los nombres de las variables que uso en la instrucción read
# son nombres que has definido tú mismo en tu script, pero cada uno de
# ellos corresponde a un campo específico en la primera línea del
# archivo `/proc/stat`.

### Estructura de `/proc/stat`

#La primera línea del archivo `/proc/stat`, que es lo que estás leyendo con el comando
# read, tiene la siguiente estructura:

# ---------    cpu  3408 0 2464 1236495 2960 0 254 0 0 0     ----------

###Te explico los campos de la línea:

#cpu: Nombre de la línea, indica que los siguientes valores son para la CPU total.

#3408: Tiempo total en modo usuario (user). Este es el tiempo que la CPU ha pasado
# ejecutando procesos en modo usuario.

#0: Tiempo total en modo usuario con prioridad modificada (nice). Esto se refiere
# al tiempo que la CPU ha pasado en modo usuario para procesos que tienen una prioridad
# nice (una forma de controlar la prioridad de la CPU de los procesos).

#2464: Tiempo total en modo sistema (system). Este es el tiempo que la CPU ha pasado
# ejecutando procesos en modo kernel (sistema).

#1236495: Tiempo total en modo inactivo (idle). Esto indica cuánto tiempo la CPU ha
# estado inactiva, es decir, sin realizar ninguna tarea.

#2960: Tiempo total en espera de entrada/salida (iowait). Este es el tiempo que la CPU
# ha estado esperando por operaciones de entrada/salida.

#0: Tiempo total en atención a interrupciones (irq). Esto es el tiempo que la CPU ha
# pasado atendiendo interrupciones de hardware.

#254: Tiempo total en atención a interrupciones de software (softirq). Esto se refiere
# al tiempo dedicado a atender interrupciones de software.

#Los siguientes ceros son campos adicionales que se usan en ciertas configuraciones, pero
# generalmente no se utilizan en un sistema normal.

### Correspondencia de las Variables

# ----- cpu user nice system idle iowait irq softirq steal guest < /proc/stat   ------

#cpu: Contiene la cadena literal cpu, que indica que esta línea es para el uso total de la CPU.
#user: Se asigna el valor `3408`, que es el tiempo total en modo usuario.
#nice: Se asigna el valor `0`, que es el tiempo en modo usuario con prioridad modificada.
#system: Se asigna el valor `2464`, que es el tiempo total en modo sistema.
#idle: Se asigna el valor `1236495`, que es el tiempo total en modo inactivo.
#iowait: Se asigna el valor `2960`, que es el tiempo total en espera de entrada/salida.
#irq: Se asigna el valor `0`, que es el tiempo dedicado a interrupciones de hardware.
#softirq: Se asigna el valor `254`, que es el tiempo dedicado a interrupciones de software.
#steal y guest: En tu salida particular, estos valores son `0` y no se utilizan generalmente en
#sistemas que no están virtualizados, pero podrían representar el tiempo que la CPU ha pasado en
#una máquina virtual (steal) y el tiempo dedicado a máquinas virtuales (guest).
