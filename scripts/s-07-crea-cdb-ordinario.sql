-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                              ║
-- ║                 Sánchez Sánchez Santiago                               ║
-- ║ @Fecha creación: 07/03/2025                                            ║
-- ║ @Descripción:    Crea una nueva CDB (Container DataBase) ordinaria     ║
-- ║                  llamada "FREE" usando la instrucción CREATE DATABASE  ║
-- ║                  con archivos de datos, redo logs y control files en   ║
-- ║                  discos separados, habilitando la arquitectura         ║
-- ║                  Multitenant (PDB$SEED).                               ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

-- Conectarse como SYSDBA                                                             
connect sys/Hola123# as sysdba                                                        

-- ────────────────────────────────────────────────────────────────────────────────
-- Etapa 1: Arrancar la instancia en modo NOMOUNT                                   
--          Esto permite asignar el parámetro de instancia y cargar el PFILE/      
--          SPFILE sin todavía asociar archivos de base de datos.                  
-- ────────────────────────────────────────────────────────────────────────────────
startup nomount                                                                      

-- Configurar salida automática en caso de error                                    
whenever sqlerror exit rollback                                                      

-- ────────────────────────────────────────────────────────────────────────────────
-- Etapa 2: Crear la base de datos CDB                                              
--          • Usuarios SYS y SYSTEM con contraseñas iniciales.                      
--          • Tres grupos de Redo Log multiplexados en distintos discos.            
--          • Archivos de datos distribuidos para SYSTEM, SYSAUX, USERS, TEMP,      
--            UNDO.                                                                 
--          • Activar opción Multitenant y crear la PDB$SEED.                       
-- ────────────────────────────────────────────────────────────────────────────────
create database free                                                                 
  /* Usuarios administrativos */                                                     
  user sys identified by system2                                                     
  user system identified by system2                                                  
                                                                                     
  /* Redo Log multiplexado (3 miembros por grupo) */                                 
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
                                                                                     
  /* Parámetros de límite */                                                         
  maxloghistory 1                                                                    
  maxlogfiles   16                                                                   
  maxlogmembers 3                                                                    
  maxdatafiles  1024                                                                 
                                                                                     
  /* Juego de caracteres */                                                          
  character set          AL32UTF8                                                    
  national character set AL16UTF16                                                   
                                                                                     
  /* SYSTEM Tablespace */                                                            
  extent management local                                                            
  datafile '/unam/bda/d12/oracle/oradata/FREE/system01.dbf'                          
          size 500m autoextend on next 10m maxsize unlimited                         
                                                                                     
  /* SYSAUX Tablespace */                                                            
  sysaux datafile '/unam/bda/d13/oracle/oradata/FREE/sysaux01.dbf'                   
          size 300m autoextend on next 10m maxsize unlimited                         
                                                                                     
  /* USERS Tablespace (predeterminado) */                                            
  default tablespace users                                                           
          datafile '/unam/bda/d14/oracle/oradata/FREE/users01.dbf'                   
          size 50m autoextend on next 10m maxsize unlimited                          
                                                                                     
  /* Temporary Tablespace */                                                         
  default temporary tablespace tempts1                                               
          tempfile '/unam/bda/d15/oracle/oradata/FREE/temp01.dbf'                    
          size 20m autoextend on next 1m maxsize unlimited                           
                                                                                     
  /* Undo Tablespace */                                                              
  undo tablespace undotbs1                                                           
          datafile '/unam/bda/d16/oracle/oradata/FREE/undotbs01.dbf'                 
          size 100m autoextend on next 5m maxsize unlimited                          
                                                                                     
  /* Activar arquitectura Multitenant */                                             
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
    sysaux  datafiles size 200m autoextend on next 10m maxsize unlimited             
                                                                                     
  local undo on                                                                      
;                                                                                    

-- ────────────────────────────────────────────────────────────────────────────────
-- Etapa 3: Reforzar la seguridad cambiando contraseñas de SYS y SYSTEM            
-- (Opcional; las contraseñas ya fueron establecidas arriba, pero se muestra        
--  la instrucción para futuros cambios).                                           
-- ────────────────────────────────────────────────────────────────────────────────
-- Cambiar contraseñas posterior a la creación                                      
alter user sys    identified by system2;                                            
alter user system identified by system2;                                            
