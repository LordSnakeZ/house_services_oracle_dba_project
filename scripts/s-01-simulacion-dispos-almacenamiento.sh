#!/bin/bash
# @Autor	Luis Héctor Chávez Mejía
# 		Santiago Sánchez Sánchez
# @Fecha 	04/03/2025
# @Descripcion	Creación de los directorios para la simulación
# 		de dispositivos de almacenamiento

# Directorio base para la creación los directorios
base_path="/unam/bda"

# Cantidad de directorios a crear
num_directorios=8

# Directorio de inicio
inicio=31

# Creación de los directorios

echo Creando $num_directorios directorios:
echo
for ((i=inicio; i<inicio+num_directorios; i++))
do

 dir="${base_path}/d${i}"
 echo "Creando directorio $(($i-$inicio+1)): $dir"
 mkdir -p "$dir"
 chmod og+rwx "$dir"
done
