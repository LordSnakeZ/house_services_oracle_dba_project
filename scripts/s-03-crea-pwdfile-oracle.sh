#!/bin/bash
# @Autor        Luis Héctor Chávez Mejía
# @Fecha        04/03/2025
# @Descripcion  Creación del archivo de passwords

archivoPwd="${ORACLE_HOME}/dbs/orapwfree"

#Comprobar que el usuario sea oracle
if [ "${USER}" != "oracle" ]; then
  echo "ERROR: el script debe ser ejecutado por el usuario oracle"
  exit 1
fi;

# Creación del archivo de passwords
orapwd FILE=${archivoPwd} \
  FORMAT=12.2 \
  SYS=password password=Hola123#

# Validando la creación del archivo de passwords
echo "validando la existencia del nuevo archivo"
if [ -f "${archivoPwd}" ]; then
  echo "OK. Archivo de password generado"
else
  echo "ERROR: El archivo de passwords no ha sido regenerado"
  exit 1
fi;

