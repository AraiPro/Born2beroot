  GNU nano 7.2                                                                                     toeverytty.sh                                                                                              
    exit 1
fi

# Archivo de bloqueo para evitar múltiples ejecuciones
LOCK_FILE="/tmp/toeverytty.lock"

# Eliminación el archivo de bloqueo cuando el script termine
trap 'if [ -f "$LOCK_FILE" ]; then echo ".........Eliminando archivo de bloqueo global........"; rm -f "$LOCK_FILE"; echo "...Archivo de bloqueo global eliminado correctamente."; fi' EXIT

# Verificar si el archivo de bloqueo existe
if [ -f "$LOCK_FILE" ]; then
    echo "El script está en ejecución y el control de errores de este programa no te permite entrar mientras dicho script esté en ejecución"
    exit 1
fi

# Crear el archivo de bloqueo para evitar ejecución repetida
touch "$LOCK_FILE"

# Verificar si el script ya se está ejecutando en alguna terminal
for tty in $(who | awk '{print $2}'); do
    # Archivos de bloqueo para cada terminal
    LOCK_FILE_TTY="/tmp/monitoring_$tty.lock"

    # Si el archivo de bloqueo existe, verificamos si el proceso asociado sigue en ejecución
    if [ -f "$LOCK_FILE_TTY" ]; then
        # Obtener el PID del proceso que creó el archivo de bloqueo (si existe)
        pid=$(cat "$LOCK_FILE_TTY")

         # Comprobar si el proceso está en ejecución
        if ps -p $pid > /dev/null 2>&1; then
            # El proceso está en ejecución, saltamos esta terminal
            continue
        else
            # El proceso no está en ejecución, eliminamos el archivo de bloqueo huérfano
            rm -f "$LOCK_FILE_TTY"
        fi
    fi

    # Si no existe un archivo de bloqueo o si el archivo de bloqueo huérfano ha sido eliminado
    # Ejecutamos el script en la terminal y bloqueamos la ejecución
    touch "$LOCK_FILE_TTY"  # Crear el archivo de bloqueo para la terminal
    echo $$ > "$LOCK_FILE_TTY"  # Guardamos el PID del proceso que está ejecutando el script

    # Ejecutar el script en la terminal y redirigir la salida
    $MONITORING_SCRIPT > /dev/$tty

    # Eliminar el archivo de bloqueo de la terminal después de la ejecución
    rm -f "$LOCK_FILE_TTY"
done

# Verificar si el archivo de bloqueo global se eliminó correctamente
if [ -f "$LOCK_FILE" ]; then
    echo "El archivo de bloqueo global debe ser eliminado..."
else
    echo "El programa ha sido interrumpido. pero dont't worry el archivo de bloqueo global se ha eliminado correctamente"
fi


#ps -p $pid: El comando ps muestra información sobre los procesos en ejecución.

#La opción -p permite especificar un PID para consultar el estado de ese proceso en particular.

# > /dev/null: La salida estándar del comando ps se redirige a /dev/null.
#Esto significa que la salida del comando no se mostrará en la consola.
#En lugar de mostrar la información del proceso, todo se descarta.

#2>&1: Esta parte redirige los errores estándar (si los hay) a la misma ubicación que la salida estándar,
#en este caso, /dev/null. Es decir, si ocurre algún error (como un PID no válido o un proceso inexistente),
#el error también se descarta.


# $$: Esta es una variable especial en Bash que contiene el PID del proceso actual, es decir, el ID del script o comando que se está ejecutando en ese momento.
