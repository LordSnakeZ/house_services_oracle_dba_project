#!/bin/bash
# @Autor	Luis Héctor Chávez Mejía
# @Fecha 	04/03/2025
# @Descripcion	Creación del diccionario de datos

mkdir /tmp/dd-logs
cd /tmp/dd-logs
perl -I $ORACLE_HOME/rdbms/admin \
$ORACLE_HOME/rdbms/admin/catcdb.pl \
--logDirectory /tmp/dd-logs \
--logFilename dd.log \
--logErrorsFilename dderror.log

sqlplus -s sys/system2 as sysdba << EOF
set serveroutput on
exec dbms_dictionary_check.full
EOF

