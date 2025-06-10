-- Script: s-00-crea_seq_historico.sql
-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                             ║
-- ║                 Sánchez Sánchez Santiago                              ║
-- ║ @Fecha creación: dd/mm/yyyy                                           ║
-- ║ @Descripción:    Crea la secuencia SEQ_HISTORICO en el esquema         ║
-- ║                  moduloServicios para los inserts en histórico        ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

CREATE SEQUENCE moduloServicios.SEQ_HISTORICO
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;
