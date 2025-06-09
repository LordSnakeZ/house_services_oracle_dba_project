--@Autor:		Luis Héctor Chávez Mejía
--@Fecha de cración 	07/03/2025
--@Descripción:		Crear una base de datos con la instrucción create database


connect sys/Hola123# as sysdba

startup nomount

whenever sqlerror exit rollback

create database free
  user sys identified by system2
  user system identified by system2
  logfile group 1 (
    '/unam/bda/d11/app/oracle/oradata/FREE/redo01a.log',
    '/unam/bda/disks/d04/app/oracle/oradata/FREE/redo01b.log',
    '/unam/bda/disks/d05/app/oracle/oradata/FREE/redo01c.log') size 50m blocksize 512,
  group 2 (
    '/unam/bda/d11/app/oracle/oradata/FREE/redo02a.log',
    '/unam/bda/disks/d04/app/oracle/oradata/FREE/redo02b.log',
    '/unam/bda/disks/d05/app/oracle/oradata/FREE/redo02c.log') size 50m blocksize 512,
  group 3 (
    '/unam/bda/d11/app/oracle/oradata/FREE/redo03a.log',
    '/unam/bda/disks/d04/app/oracle/oradata/FREE/redo03b.log',
    '/unam/bda/disks/d05/app/oracle/oradata/FREE/redo03c.log') size 50m blocksize 512
  maxloghistory 1
  maxlogfiles 16
  maxlogmembers 3
  maxdatafiles 1024
  character set AL32UTF8
  national character set AL16UTF16
  extent management local
    datafile '/unam/bda/d12/oracle/oradata/FREE/system01.dbf'
      size 500m autoextend on next 10m maxsize unlimited
  sysaux datafile '/unam/bda/d13/oracle/oradata/FREE/sysaux01.dbf'
    size 300m autoextend on next 10m maxsize unlimited
  default tablespace users
    datafile '/unam/bda/d14/oracle/oradata/FREE/users01.dbf'
    size 50m autoextend on next 10m maxsize unlimited
  default temporary tablespace tempts1
    tempfile '/unam/bda/d15/oracle/oradata/FREE/temp01.dbf'
    size 20m autoextend on next 1m maxsize unlimited
  undo tablespace undotbs1
    datafile '/unam/bda/d16/oracle/oradata/FREE/undotbs01.dbf'
    size 100m autoextend on next 5m maxsize unlimited
  enable pluggable database
    seed
      file_name_convert = (
        '/unam/bda/d12/oracle/oradata/FREE', '/unam/bda/d17/pdbseed',
        '/unam/bda/d13/oracle/oradata/FREE', '/unam/bda/d17/pdbseed',
        '/unam/bda/d14/oracle/oradata/FREE', '/unam/bda/d17/pdbseed',
        '/unam/bda/d15/oracle/oradata/FREE', '/unam/bda/d17/pdbseed',
        '/unam/bda/d16/oracle/oradata/FREE', '/unam/bda/d17/pdbseed'
       )
    system datafiles size 250m autoextend on next 10m maxsize unlimited
    sysaux datafiles size 200m autoextend on next 10m maxsize unlimited
  local undo on
;


alter user sys identified by system2;
alter user system identified by system2;
