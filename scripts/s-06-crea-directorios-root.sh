#!/bin/bash
# @Autor	Luis Héctor Chávez Mejía
# @Fecha 	04/03/2025
# @Descripcion	Creación de los directiorios para la nueva CDB


# Disco de inicio:
inicio=12
num_directorios=5
base_path="/unam/bda"

# Asegurar que el usuario es root
#if [ "${USER}" != "root" ]; then
#  echo "ERROR: el script debe ser ejecutado por el usuario root"
#  exit 1
#fi;

# A. Crear directorios para los datafiles del contenedor cdb$root

for ((i=inicio; i<inicio+num_directorios; i++))
do

 dir="${base_path}/d${i}"
 cd $dir
 mkdir -p oracle
 chown -R oracle:oinstall oracle
 chmod -R 750 oracle

done



for ((i=inicio; i<inicio+num_directorios; i++))
do

 dir="${base_path}/d${i}/oracle"
 cd $dir
 mkdir -p oradata/${ORACLE_SID^^}
 chown -R oracle:oinstall oradata
 chmod -R 750 oradata

done

# B. Crear el directorio para la PDB pdb$seed
dir="${base_path}/d17"
cd $dir
mkdir pdbseed
chown oracle:oinstall pdbseed
chmod 750 pdbseed

# C. Crear directorios para Redo Log y control files

#  ->Primera estructura (Ubicada en la FRA)
cd /unam/bda/d11
echo creando directorio app/oracle/oradata/${ORACLE_SID^^}
mkdir -p app/oracle/oradata/${ORACLE_SID^^}
chown -R oracle:oinstall app
chmod -R 750 app

#  ->Segunda estructura
cd /unam/bda/disks/d04
mkdir -p app/oracle/oradata/${ORACLE_SID^^}
chown -R oracle:oinstall app
chmod -R 750 app

#  ->Tercera estructura
cd /unam/bda/disks/d05
mkdir -p app/oracle/oradata/${ORACLE_SID^^}
chown -R oracle:oinstall app
chmod -R 750 app

# D. Mostrar el contenido de los directorios creados
#echo "Mostrando directorio de data files"
#ls -l /opt/oracle/oradata
#echo "Mostrando directorios para control files y Redo Logs"
#ls -l /unam/bda/disks/d0*/app/oracle/oradata
