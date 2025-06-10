-- Script: s-27-creacion_tabla_control_media.sql
-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                             ║
-- ║                 Sánchez Sánchez Santiago                              ║
-- ║ @Fecha creación: dd/mm/yyyy                                           ║
-- ║ @Descripción:    Crea la tabla de control para pruebas de media       ║
-- ║                  recovery y vista comparativa Manual vs DRA          ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

CREATE TABLE sistema.control_media_recovery (
  prueba_id                  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  fecha_prueba               TIMESTAMP             NOT NULL,
  datafile_id                NUMBER                NOT NULL,
  tablespace_name            VARCHAR2(30)          NOT NULL,
  datafile_name              VARCHAR2(256)         NOT NULL,
  tipo_dano                  VARCHAR2(20)          NOT NULL,
  backup_existente           VARCHAR2(1)           NOT NULL,
  recovery_manual_time_sec   NUMBER(10,3),
  recovery_manual_result     VARCHAR2(20),
  recovery_manual_log        VARCHAR2(500),
  recovery_dra_time_sec      NUMBER(10,3),
  recovery_dra_result        VARCHAR2(20),
  recovery_dra_log           VARCHAR2(500),
  observaciones              VARCHAR2(500)
) TABLESPACE sistema;

COMMENT ON TABLE sistema.control_media_recovery IS
  'Registro de pruebas de media recovery';
COMMENT ON COLUMN sistema.control_media_recovery.tipo_dano IS
  'Tipo de daño simulado (SIMULATED/CORRUPT/DELETED)';

CREATE OR REPLACE VIEW sistema.vw_comparativo_recovery AS
SELECT 
  prueba_id,
  TO_CHAR(fecha_prueba, 'DD-MON HH24:MI') AS fecha,
  tablespace_name,
  recovery_manual_time_sec AS manual_time,
  recovery_dra_time_sec    AS dra_time,
  ROUND(
    recovery_manual_time_sec/NULLIF(recovery_dra_time_sec,0)
  ,2) AS ratio,
  CASE 
    WHEN recovery_manual_time_sec < recovery_dra_time_sec THEN 'MANUAL'
    WHEN recovery_dra_time_sec < recovery_manual_time_sec THEN 'DRA'
    ELSE 'EQUAL'
  END AS mas_rapido
FROM sistema.control_media_recovery
ORDER BY fecha_prueba DESC;
