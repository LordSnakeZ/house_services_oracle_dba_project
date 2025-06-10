-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                              ║
-- ║                 Sánchez Sánchez Santiago                               ║
-- ║ @Fecha creación: 09/03/2025                                            ║
-- ║ @Descripción:    Crea la PDB ordinaria "CHSABDA_S2" dentro de la CDB   ║
-- ║                  "FREE", la abre en modo lectura/escritura y guarda    ║
-- ║                  su estado para que permanezca abierta tras un        ║
-- ║                  reinicio de la instancia.                             ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

-- =====================================================================
--  Conexión                                                          
-- =====================================================================
CONNECT sys/system2 AS sysdba;

-- =====================================================================
--  Manejo de errores: si ocurre un error, hacer ROLLBACK y salir      
-- =====================================================================
WHENEVER SQLERROR EXIT ROLLBACK;

-- =====================================================================
--  Creación de la nueva PDB                                            
-- =====================================================================
-- * chsabda_s2         : Nombre de la PDB                               
-- * chsa_admin         : Usuario administrador local de la PDB         
-- * path_prefix        : Ruta base bajo la cual se crearán los datafiles
-- * file_name_convert  : Patrón para convertir rúta de ficheros desde   
--                        la PDB seed (pdbseed) hacia la nueva PDB.      
-- ---------------------------------------------------------------------
CREATE PLUGGABLE DATABASE chsabda_s2
  ADMIN USER chsa_admin IDENTIFIED BY chsa_admin
  PATH_PREFIX = '/unam/bda/d17'
  FILE_NAME_CONVERT = (
    '/pdbseed/',
    '/chsabda_s2/'
  );

-- =====================================================================
--  Apertura inicial de la PDB                                          
-- =====================================================================
PROMPT Abriendo la PDB CHSABDA_S2...
ALTER PLUGGABLE DATABASE chsabda_s2 OPEN;

-- =====================================================================
--  Persistencia del estado (SAVE STATE)                                
-- =====================================================================
PROMPT Guardando el estado de la PDB para que se abra automáticamente.
ALTER PLUGGABLE DATABASE chsabda_s2 SAVE STATE;

PROMPT ***** PDB CHSABDA_S2 creada y abierta correctamente *****
