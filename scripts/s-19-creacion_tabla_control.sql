-- Script: s-19-creacion_tabla_control.sql
-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                             ║
-- ║                 Sánchez Sánchez Santiago                              ║
-- ║ @Fecha creación: dd/mm/yyyy                                           ║
-- ║ @Descripción:    Crea la tabla de control de simulaciones de carga    ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

CREATE TABLE sistema.control_carga (
  ejecucion_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  fecha_ejecucion    TIMESTAMP                 NOT NULL,
  operaciones        NUMBER                    NOT NULL,
  redo_generado_mb   NUMBER(10,2)              NOT NULL,
  tiempo_segundos    NUMBER(10,2)              NOT NULL,
  completado         CHAR(1)    DEFAULT 'Y'    CHECK (completado IN ('Y','N'))
) TABLESPACE sistema;

COMMENT ON TABLE sistema.control_carga IS
  'Registro de ejecuciones de simulación de carga diaria';
COMMENT ON COLUMN sistema.control_carga.fecha_ejecucion IS
  'Fecha y hora de ejecución';
COMMENT ON COLUMN sistema.control_carga.operaciones IS
  'Número de operaciones realizadas';
COMMENT ON COLUMN sistema.control_carga.redo_generado_mb IS
  'REDO generado en MB';
COMMENT ON COLUMN sistema.control_carga.tiempo_segundos IS
  'Tiempo de ejecución en segundos';
