-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                             ║
-- ║                 Sánchez Sánchez Santiago                              ║
-- ║ @Fecha creación: 10/06/2025                                           ║
-- ║ @Descripción:    Simula carga diaria generando ~30MB de REDO en la BD  ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

SET SERVEROUTPUT ON;
SET TIMING ON;

DECLARE
  v_start_time    TIMESTAMP;
  v_redo_size     NUMBER;
  v_target_redo   NUMBER := 30 * 1024 * 1024;
  v_operations    NUMBER := 0;
  v_servicio_id   NUMBER;
  v_cliente_id    NUMBER;
  v_proveedor_id  NUMBER;
BEGIN
  SELECT VALUE INTO v_redo_size FROM V$SYSSTAT WHERE NAME = 'redo size';
  DBMS_OUTPUT.PUT_LINE('Iniciando simulación de carga diaria...');
  DBMS_OUTPUT.PUT_LINE('REDO inicial: ' || ROUND(v_redo_size/1024/1024,2) || ' MB');
  v_start_time := SYSTIMESTAMP;

  WHILE v_redo_size < v_target_redo LOOP
    v_operations := v_operations + 1;

    -- 1) Actualiza status
    UPDATE moduloServicios.SERVICIO
       SET STATUS_SERVICIO_ID =
           CASE WHEN STATUS_SERVICIO_ID < 8 THEN STATUS_SERVICIO_ID + 1 ELSE 3 END
     WHERE SERVICIO_ID = MOD(v_operations,2000) + 1;

    -- 2) Inserta histórico (ignora duplicados)
    BEGIN
      INSERT INTO moduloServicios.HISTORICO_STATUS_SERVICIO (
        HISTORICO_STATUS_SERVICIO_ID,
        FECHA_STATUS,
        STATUS_SERVICIO_ID,
        SERVICIO_ID
      ) VALUES (
        moduloServicios.SEQ_HISTORICO.NEXTVAL,
        SYSDATE,
        MOD(v_operations, 8) + 1,
        MOD(v_operations,2000) + 1
      );
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN NULL;
    END;

    -- 3) Actualiza email
    UPDATE moduloUsuarios.CLIENTE
       SET EMAIL_USUARIO = 'user_' || MOD(v_operations,2000) || '@' ||
            CASE WHEN MOD(v_operations,2)=0 THEN 'gmail.com' ELSE 'unam.mx' END
     WHERE CLIENTE_ID = MOD(v_operations,2000) + 1;

    -- 4) Insertar nuevos servicios 10% prob.
    IF MOD(v_operations,10)=0 THEN
      SELECT CLIENTE_ID
        INTO v_cliente_id
        FROM (SELECT CLIENTE_ID FROM moduloUsuarios.CLIENTE ORDER BY DBMS_RANDOM.VALUE)
       WHERE ROWNUM=1;

      SELECT PROVEEDOR_SERVICIO_ID
        INTO v_proveedor_id
        FROM (SELECT PROVEEDOR_SERVICIO_ID FROM moduloUsuarios.PROVEEDOR_SERVICIO ORDER BY DBMS_RANDOM.VALUE)
       WHERE ROWNUM=1;

      v_servicio_id := moduloServicios.seq_servicio.NEXTVAL;

      INSERT INTO moduloServicios.SERVICIO (
        SERVICIO_ID, FECHA_SERVICIO, DESCRIPCION, DOCUMENTO,
        TARJETA_ID_FK, PROVEEDOR_SERVICIO_ID_FK, STATUS_SERVICIO_ID
      ) VALUES (
        v_servicio_id, SYSDATE,
        'Servicio generado automáticamente '||v_operations,
        NULL,
        MOD(v_operations,2000)+1,
        v_proveedor_id,
        1
      );
    END IF;

    IF MOD(v_operations,50)=0 THEN
      COMMIT;
      SELECT VALUE INTO v_redo_size FROM V$SYSSTAT WHERE NAME = 'redo size';
      DBMS_OUTPUT.PUT_LINE(
        'Operaciones: '||v_operations||
        ' - REDO acumulado: '||ROUND(v_redo_size/1024/1024,2)||' MB'
      );
    END IF;
  END LOOP;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Simulación completada:');
  DBMS_OUTPUT.PUT_LINE('- Operaciones realizadas: '||v_operations);
  DBMS_OUTPUT.PUT_LINE('- REDO generado: '||ROUND(v_redo_size/1024/1024,2)||' MB');
  DBMS_OUTPUT.PUT_LINE(
    '- Tiempo transcurrido: '||
    EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time))||' s'
  );
END;
/
