-- Script: s-20-simulacion_redo_varios_dias.sql
-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                             ║
-- ║                 Sánchez Sánchez Santiago                              ║
-- ║ @Fecha creación: dd/mm/yyyy                                           ║
-- ║ @Descripción:    Simula carga de trabajo varios días para acumular   ║
-- ║                  REDO y preparar media recovery                       ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

SET SERVEROUTPUT ON
SET LINESIZE  200
SET PAGESIZE  1000

DECLARE
  v_dias_simulacion   NUMBER := 3;    -- Días a simular
  v_intervalo_minutes NUMBER := 120;  -- Cada 2 horas
  v_iteraciones       NUMBER;
  v_redo_total        NUMBER := 0;
  v_redo_size         NUMBER;
  v_redo_anterior     NUMBER := 0;    -- Inicializado para delta REDO
  v_start_time        TIMESTAMP;
BEGIN
  -- Calcular total de iteraciones
  v_iteraciones := v_dias_simulacion * 24 * (60 / v_intervalo_minutes);

  -- Leer REDO inicial
  SELECT VALUE
    INTO v_redo_size
  FROM V$SYSSTAT
  WHERE NAME = 'redo size';
  v_redo_anterior := v_redo_size;

  DBMS_OUTPUT.PUT_LINE(
    'Iniciando simulación de ' || v_dias_simulacion || ' días...'
  );
  DBMS_OUTPUT.PUT_LINE(
    'REDO inicial: ' || ROUND(v_redo_size/1024/1024,2) || ' MB'
  );
  v_start_time := SYSTIMESTAMP;

  FOR i IN 1..v_iteraciones LOOP
    DBMS_OUTPUT.PUT_LINE('Ciclo ' || i || ' de ' || v_iteraciones);

    -- 1) Operaciones en módulo de usuarios (20%)
    FOR j IN 1..20 LOOP
      UPDATE moduloUsuarios.CLIENTE
      SET TELEFONO = '55'
        || LPAD(FLOOR(DBMS_RANDOM.VALUE(1000,9999)),4)
        || LPAD(FLOOR(DBMS_RANDOM.VALUE(1000,9999)),4)
      WHERE CLIENTE_ID = MOD(i+j,2000) + 1;
      COMMIT;
    END LOOP;

    -- 2) Operaciones en módulo de servicios (80%)
    FOR j IN 1..80 LOOP
      UPDATE moduloServicios.SERVICIO
      SET STATUS_SERVICIO_ID = MOD(STATUS_SERVICIO_ID,8) + 1
      WHERE SERVICIO_ID = MOD(i+j,2000) + 1;

      INSERT INTO moduloServicios.HISTORICO_STATUS_SERVICIO
      VALUES (
        SEQ_HISTORICO.NEXTVAL,
        SYSDATE,
        MOD(i+j,8)+1,
        MOD(i+j,2000)+1
      );
      COMMIT;
    END LOOP;

    -- 3) Espera para simular paso de tiempo
    DBMS_LOCK.SLEEP(v_intervalo_minutes * 60);

    -- 4) Leer REDO y acumular delta
    DECLARE
      v_actual NUMBER;
    BEGIN
      SELECT VALUE INTO v_actual
      FROM V$SYSSTAT WHERE NAME = 'redo size';

      v_redo_total    := v_redo_total + (v_actual - v_redo_anterior);
      v_redo_anterior := v_actual;

      DBMS_OUTPUT.PUT_LINE(
        'REDO acumulado: ' || ROUND(v_redo_total/1024/1024,2) || ' MB'
      );
    END;
  END LOOP;

  -- Resumen final
  DBMS_OUTPUT.PUT_LINE('Simulación completada:');
  DBMS_OUTPUT.PUT_LINE(
    '- Tiempo total: '
    || EXTRACT(DAY  FROM (SYSTIMESTAMP - v_start_time)) || ' días '
    || EXTRACT(HOUR FROM (SYSTIMESTAMP - v_start_time)) || ' horas'
  );
  DBMS_OUTPUT.PUT_LINE(
    '- REDO total generado: '
    || ROUND(v_redo_total/1024/1024,2) || ' MB'
  );
END;
/
