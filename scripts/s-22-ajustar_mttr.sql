-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                             ║
-- ║                 Sánchez Sánchez Santiago                              ║
-- ║ @Fecha creación: 10/06/2025                                           ║
-- ║ @Descripción:    Ajusta dynámicamente el parámetro fast_start_mttr_target║
-- ║                  en función del tiempo promedio de recovery de la BD en  ║
-- ║                  los últimos 7 días                                     ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

-- Configuración de la sesión para mostrar resultados
SET SERVEROUTPUT ON;      -- Muestra salidas de DBMS_OUTPUT
SET LINESIZE 200;         -- Ancho de línea para salida legible
SET PAGESIZE 1000;        -- Número de líneas antes de paginar

DECLARE
  v_avg_recovery NUMBER;      -- Tiempo promedio de recovery
  v_current_mttr NUMBER;      -- Valor actual de fast_start_mttr_target
  v_new_mttr NUMBER;          -- Nuevo valor calculado de MTTR
BEGIN
  -- 1. Obtener tiempo promedio de recovery de la última semana
  SELECT AVG(recovery_time_sec)
    INTO v_avg_recovery
    FROM sistema.control_recovery
   WHERE fecha_prueba > SYSDATE - 7;

  -- 2. Leer el valor actual de MTTR target
  SELECT value
    INTO v_current_mttr
    FROM v$parameter
   WHERE name = 'fast_start_mttr_target';

  DBMS_OUTPUT.PUT_LINE('=== Análisis MTTR Actual ===');
  DBMS_OUTPUT.PUT_LINE('Tiempo promedio recovery (7d): ' || ROUND(v_avg_recovery,2) || ' s');
  DBMS_OUTPUT.PUT_LINE('MTTR target actual: ' || v_current_mttr || ' s');

  -- 3. Calcular nuevo MTTR como 80% del promedio obtenido
  v_new_mttr := ROUND(v_avg_recovery * 0.8);

  -- 4. Asegurar que el nuevo valor esté en rango válido (1–3600 s)
  IF v_new_mttr < 1 THEN
    v_new_mttr := 1;
  ELSIF v_new_mttr > 3600 THEN
    v_new_mttr := 3600;
  END IF;

  -- 5. Aplicar cambio si difiere del valor actual
  IF v_new_mttr != v_current_mttr THEN
    EXECUTE IMMEDIATE 'ALTER SYSTEM SET fast_start_mttr_target=' || v_new_mttr || ' SCOPE=BOTH';
    DBMS_OUTPUT.PUT_LINE('Nuevo MTTR target configurado: ' || v_new_mttr || ' s');
  ELSE
    DBMS_OUTPUT.PUT_LINE('MTTR target ya optimizado. No se realizaron cambios.');
  END IF;

  -- 6. Proveer recomendaciones adicionales para optimización
  DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== Recomendaciones ===');
  DBMS_OUTPUT.PUT_LINE('- Ajustar log_checkpoint_interval si se desea más frecuencia de checkpoints');
  DBMS_OUTPUT.PUT_LINE('- Incrementar db_cache_size para reducir lecturas físicas');
  DBMS_OUTPUT.PUT_LINE('- Utilizar discos de mayor performance para faster IO');

  -- 7. Mostrar historial de recovery (últimos 7 días)
  DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== Historial Recovery (últimos 7d) ===');
  FOR r IN (
    SELECT TO_CHAR(fecha_prueba,'DD-MON HH24:MI') AS fecha,
           recovery_time_sec,
           fast_start_mttr_target,
           redo_generado_mb
      FROM sistema.control_recovery
     WHERE fecha_prueba > SYSDATE - 7
     ORDER BY fecha_prueba DESC
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(
      RPAD(r.fecha,12) || ' ' ||
      'Recov: ' || RPAD(r.recovery_time_sec||'s',10) || ' ' ||
      'MTTR: '  || RPAD(r.fast_start_mttr_target||'s',8) || ' ' ||
      'REDO: '  || r.redo_generado_mb || ' MB'
    );
  END LOOP;
END;
/
