-- Script: s-23-creacion_tabla_control_recovery.sql
-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                             ║
-- ║                 Sánchez Sánchez Santiago                              ║
-- ║ @Fecha creación: dd/mm/yyyy                                           ║
-- ║ @Descripción:    Crea la tabla de control de pruebas de instance      ║
-- ║                  recovery                                               ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

CREATE TABLE sistema.control_recovery (
  prueba_id              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  fecha_prueba           TIMESTAMP             NOT NULL,
  recovery_time_sec      NUMBER(10,3)         NOT NULL,
  redo_generado_mb       NUMBER(10,2)         NOT NULL,
  fast_start_mttr_target NUMBER               NOT NULL,
  observaciones          VARCHAR2(500)
) TABLESPACE sistema;

COMMENT ON TABLE sistema.control_recovery IS
  'Registro de pruebas de instance recovery';
COMMENT ON COLUMN sistema.control_recovery.recovery_time_sec IS
  'Tiempo real de recovery en segundos';
COMMENT ON COLUMN sistema.control_recovery.redo_generado_mb IS
  'REDO generado antes del recovery en MB';
COMMENT ON COLUMN sistema.control_recovery.fast_start_mttr_target IS
  'Valor del parámetro MTTR durante la prueba';
