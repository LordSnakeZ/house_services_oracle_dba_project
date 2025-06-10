-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                             ║
-- ║                 Sánchez Sánchez Santiago                              ║
-- ║ @Fecha creación: 10/06/2025                                           ║
-- ║ @Descripción:    Simula carga diaria generando ~30MB de REDO en la BD  ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

-- Habilita la salida de DBMS_OUTPUT y medición de tiempos
SET SERVEROUTPUT ON;
SET TIMING ON;

DECLARE
  v_start_time    TIMESTAMP;        -- Marca de tiempo de inicio de simulación
  v_redo_size     NUMBER;           -- Tamaño actual de REDO en bytes
  v_target_redo   NUMBER := 30 * 1024 * 1024; -- Objetivo de 30MB de REDO
  v_operations    NUMBER := 0;      -- Contador de operaciones realizadas
  v_servicio_id   NUMBER;           -- ID para nuevos servicios (10% probabilidad)
  v_cliente_id    NUMBER;           -- Cliente aleatorio para nuevos servicios
  v_proveedor_id  NUMBER;           -- Proveedor aleatorio para nuevos servicios
BEGIN
  -- Obtener tamaño de REDO inicial
  SELECT VALUE INTO v_redo_size
    FROM V$SYSSTAT
   WHERE NAME = 'redo size';

  DBMS_OUTPUT.PUT_LINE('Iniciando simulación de carga diaria...');
  DBMS_OUTPUT.PUT_LINE('REDO inicial: ' || ROUND(v_redo_size/1024/1024,2) || ' MB');
  v_start_time := SYSTIMESTAMP;

  -- Bucle principal: repite operaciones hasta alcanzar ~30MB de REDO
  WHILE v_redo_size < v_target_redo LOOP
    v_operations := v_operations + 1;

    -- 1) Actualizar status de un servicio existente
    UPDATE moduloServicios.SERVICIO
       SET STATUS_SERVICIO_ID = CASE
                                   WHEN STATUS_SERVICIO_ID < 8 THEN STATUS_SERVICIO_ID + 1
                                   ELSE 3 -- Reiniciar ciclo en caso de superar valor
                                 END
     WHERE SERVICIO_ID = MOD(v_operations, 2000) + 1;

    -- 2) Insertar entrada en histórico de status
    INSERT INTO moduloServicios.HISTORICO_STATUS_SERVICIO (
      HISTORICO_STATUS_SERVICIO_ID,
      FECHA_STATUS,
      STATUS_SERVICIO_ID,
      SERVICIO_ID
    ) VALUES (
      SEQ_HISTORICO.NEXTVAL,
      SYSDATE,
      MOD(v_operations, 8) + 1,
      MOD(v_operations, 2000) + 1
    );

    -- 3) Actualizar email de un cliente para generar REDO adicional
    UPDATE moduloUsuarios.CLIENTE
       SET EMAIL_USUARIO = 'user_' || MOD(v_operations, 2000) || '@' ||
           CASE WHEN MOD(v_operations, 2) = 0 THEN 'gmail.com' ELSE 'unam.mx' END
     WHERE CLIENTE_ID = MOD(v_operations, 2000) + 1;

    -- 4) Insertar nuevos servicios con probabilidad 10%
    IF MOD(v_operations, 10) = 0 THEN
      -- Obtener valores aleatorios de cliente y proveedor
      SELECT CLIENTE_ID
        INTO v_cliente_id
        FROM (
          SELECT CLIENTE_ID FROM moduloUsuarios.CLIENTE ORDER BY DBMS_RANDOM.VALUE
        ) WHERE ROWNUM = 1;

      SELECT PROVEEDOR_SERVICIO_ID
        INTO v_proveedor_id
        FROM (
          SELECT PROVEEDOR_SERVICIO_ID FROM moduloUsuarios.PROVEEDOR_SERVICIO ORDER BY DBMS_RANDOM.VALUE
        ) WHERE ROWNUM = 1;

      -- Calcular nuevo ID de servicio
      SELECT MAX(SERVICIO_ID) + 1 INTO v_servicio_id FROM moduloServicios.SERVICIO;

      INSERT INTO moduloServicios.SERVICIO (
        SERVICIO_ID,
        FECHA_SERVICIO,
        DESCRIPCION,
        DOCUMENTO,
        TARJETA_ID_FK,
        PROVEEDOR_SERVICIO_ID_FK,
        STATUS_SERVICIO_ID
      ) VALUES (
        v_servicio_id,
        SYSDATE,
        'Servicio generado automáticamente ' || v_operations,
        NULL,
        MOD(v_operations, 2000) + 1,
        v_proveedor_id,
        1 -- Estado inicial 'SOLICITADO'
      );
    END IF;

    -- Commit cada 50 operaciones y re-evaluar tamaño de REDO
    IF MOD(v_operations, 50) = 0 THEN
      COMMIT;
      SELECT VALUE INTO v_redo_size FROM V$SYSSTAT WHERE NAME = 'redo size';
      DBMS_OUTPUT.PUT_LINE('Operaciones: ' || v_operations ||
                           ' - REDO acumulado: ' || ROUND(v_redo_size/1024/1024,2) || ' MB');
    END IF;
  END LOOP;

  COMMIT; -- Asegura persistencia final de todos los cambios

  -- Resultados de la simulación
  DBMS_OUTPUT.PUT_LINE('Simulación completada:');
  DBMS_OUTPUT.PUT_LINE('- Operaciones realizadas: ' || v_operations);
  DBMS_OUTPUT.PUT_LINE('- REDO generado: ' || ROUND(v_redo_size/1024/1024,2) || ' MB');
  DBMS_OUTPUT.PUT_LINE('- Tiempo transcurrido (segundos): ' ||
                      EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)));
END;
/
