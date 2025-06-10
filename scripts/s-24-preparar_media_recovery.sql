-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                             ║
-- ║                 Sánchez Sánchez Santiago                              ║
-- ║ @Fecha creación: 10/06/2025                                           ║
-- ║ @Descripción:    Prepara ambiente y simula daño a datafile para        ║
-- ║                  media recovery                                        ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

-- Habilita salida de DBMS_OUTPUT y medición de tiempos
SET SERVEROUTPUT ON
SET LINESIZE 200
SET PAGESIZE 1000

DECLARE
  v_datafile_id      NUMBER;        -- ID del datafile seleccionado
  v_datafile_name    VARCHAR2(256); -- Ruta completa del datafile
  v_tablespace_name  VARCHAR2(30);  -- Nombre del tablespace
  v_backup_exists    NUMBER;        -- Indicador de existencia de backup
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== Preparando simulación de Media Recovery ===');
  
  -- 1. Escoge un datafile del módulo de servicios para simular daño
  SELECT f.file_id, t.name, f.name
    INTO v_datafile_id, v_tablespace_name, v_datafile_name
    FROM (
      SELECT f.file_id, t.name, f.name
        FROM v$datafile f
        JOIN v$tablespace t ON f.ts# = t.ts#
       WHERE t.name LIKE 'TBS_SERVICIO%' OR t.name LIKE 'TBS_MOD_SERVICIO%'
       ORDER BY DBMS_RANDOM.VALUE  -- Orden aleatorio
    ) WHERE ROWNUM = 1;
  
  DBMS_OUTPUT.PUT_LINE('Datafile para simular daño: ID=' || v_datafile_id ||
                       ', TS=' || v_tablespace_name ||
                       ', Ruta=' || v_datafile_name);
  
  -- 2. Verifica que exista un backup reciente (últimas 24 horas)
  SELECT COUNT(*) INTO v_backup_exists
    FROM v$backup_datafile
   WHERE file# = v_datafile_id
     AND completion_time > SYSDATE - 1;
  
  IF v_backup_exists = 0 THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: No existe backup reciente para el datafile.');
    DBMS_OUTPUT.PUT_LINE('Ejecute un backup completo antes de continuar.');
    RETURN;  -- Sale si no hay backup
  END IF;
  
  -- 3. Pone offline el tablespace para simular daño al datafile
  EXECUTE IMMEDIATE 'ALTER TABLESPACE ' || v_tablespace_name || ' OFFLINE IMMEDIATE';
  DBMS_OUTPUT.PUT_LINE('Tablespace ' || v_tablespace_name || ' puesto OFFLINE para simular daño.');
  DBMS_OUTPUT.PUT_LINE('=== Proceda con la recuperación ===');
  
  -- 4. Registra el evento en la tabla de control de media recovery
  INSERT INTO sistema.control_media_recovery (
    fecha_prueba,
    datafile_id,
    tablespace_name,
    datafile_name,
    tipo_dano,
    backup_existente
  ) VALUES (
    SYSDATE,
    v_datafile_id,
    v_tablespace_name,
    v_datafile_name,
    'SIMULATED',
    'Y'
  );
  COMMIT;
  
  -- 5. Proporciona instrucciones de recovery manual y DRA
  DBMS_OUTPUT.PUT_LINE(CHR(10) || '*** Instrucciones de Media Recovery Manual ***');
  DBMS_OUTPUT.PUT_LINE('1. RMAN> RESTORE DATAFILE ' || v_datafile_id || ';');
  DBMS_OUTPUT.PUT_LINE('2. RMAN> RECOVER DATAFILE ' || v_datafile_id || ';');
  DBMS_OUTPUT.PUT_LINE('3. SQL> ALTER TABLESPACE ' || v_tablespace_name || ' ONLINE;');
  
  DBMS_OUTPUT.PUT_LINE(CHR(10) || '*** Instrucciones con DRA (Data Recovery Advisor) ***');
  DBMS_OUTPUT.PUT_LINE('1. RMAN> LIST FAILURE;');
  DBMS_OUTPUT.PUT_LINE('2. RMAN> ADVISE FAILURE;');
  DBMS_OUTPUT.PUT_LINE('3. RMAN> REPAIR FAILURE;');
END;
/
