-- Script: s-00-crea_seq_historico.sql
-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                             ║
-- ║                 Sánchez Sánchez Santiago                              ║
-- ║ @Fecha creación: dd/mm/yyyy                                           ║
-- ║ @Descripción:    Crea la secuencia SEQ_HISTORICO en el esquema         ║
-- ║                  moduloServicios para los inserts en histórico        ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

-- Crea (si no existe) en tu PDB o esquema
CREATE SEQUENCE moduloServicios.seq_servicio
  START WITH (SELECT NVL(MAX(servicio_id),0)+1 FROM moduloServicios.servicio)
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

CREATE SEQUENCE moduloServicios.SEQ_HISTORICO
  START WITH (SELECT NVL(MAX(HISTORICO_STATUS_SERVICIO_ID),0)+1 FROM moduloServicios.HISTORICO_STATUS_SERVICIO)
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;
