#!/bin/bash
# @Autor        Luis Héctor Chávez Mejía
# @Fecha        04/03/2025
# @Descripcion	Creación del pfile

echo "1. Creación de un archivo de parámetros básicos"
export ORACLE_SID=free
pfile=$ORACLE_HOME/dbs/init${ORACLE_SID}.ora

if [ -f "${pfile}" ]; then
  read -p "El archivo ${pfile} ya existe, [enter] para sobrescribir"
fi;

echo \
"db_name=${ORACLE_SID}
memory_target=768M
control_files=(
  /unam/bda/d11/app/oracle/oradata/${ORACLE_SID^^}/control01.ctl,
  /unam/bda/disks/d04/app/oracle/oradata/${ORACLE_SID^^}/control02.ctl,
  /unam/bda/disks/d05/app/oracle/oradata/${ORACLE_SID^^}/control03.ctl
)
db_domain=fi.unam
enable_pluggable_database=true
db_recovery_file_dest_size=20G
db_recovery_file_dest='/unam/bda/d11'
db_flashback_retention_target=1440
log_archive_max_processes=4
log_archive_format=arch_%t_%s_%r.arc
log_archive_dest_1='LOCATION=/unam/bda/d11 MANDATORY'
log_archive_dest_2='LOCATION=/unam/bda/d18'
" >$pfile

echo "Listo"
echo "Comprobando la existencia y contenido del PFILE"
echo ""
cat ${pfile}



