-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                              ║
-- ║                 Sánchez Sánchez Santiago                               ║
-- ║ @Fecha creación: 09/03/2025                                            ║
-- ║ @Descripción:    Crea un SPFILE (Server Parameter File) a partir      ║
-- ║                  del PFILE previamente configurado para la instancia  ║
-- ║                  Oracle actual.                                        ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

-- ======================================================================
-- 1. Conexión como SYSDBA                                                
--    Se utiliza la cuenta SYS con privilegios SYSDBA para realizar       
--    operaciones críticas de instancia.                                 
-- ======================================================================
CONNECT sys/Hola123# AS SYSDBA;

-- ======================================================================
-- 2. Creación del SPFILE                                                 
--    El SPFILE (Server Parameter File) es un archivo binario             
--    mantenido por el motor Oracle que almacena los parámetros de        
--    inicialización de forma dinámica.                                   
--    • FROM PFILE  → Usa el archivo de texto init<SID>.ora (PFILE)       
--      existente para generar el nuevo spfile<SID>.ora.                  
-- ======================================================================
CREATE SPFILE FROM PFILE;

-- ======================================================================
-- 3. Verificación desde el shell                                         
--    Mediante un comando externo (prefijo "!" en SQL*Plus) listamos      
--    el archivo recién creado para confirmar su existencia y ruta.       
--    ${ORACLE_SID} y ${ORACLE_HOME} deben estar exportados en el         
--    entorno de la sesión.                                               
-- ======================================================================
!ls ${ORACLE_HOME}/dbs/spfile${ORACLE_SID}.ora;
