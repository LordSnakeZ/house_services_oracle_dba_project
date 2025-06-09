--@Autor:		Luis Héctor Chávez Mejía
--@Fecha de cración 	09/03/2025
--@Descripción:		Creación del archivo de parámetros spfile

connect sys/Hola123# as sysdba

create spfile from pfile;

!ls ${ORACLE_HOME}/dbs/spfile${ORACLE_SID}.ora
