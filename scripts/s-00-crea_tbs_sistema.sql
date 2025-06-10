-- Script: s-00-crea_tbs_sistema.sql
-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                             ║
-- ║                 Sánchez Sánchez Santiago                              ║
-- ║ @Fecha creación: dd/mm/yyyy                                           ║
-- ║ @Descripción:    Crea el tablespace “sistema” usado por las tablas     ║
-- ║                  de control de simulaciones y recovery                 ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

CREATE TABLESPACE sistema
  DATAFILE '/unam/bda/d11/tbs_sistema01.dbf'  -- Revisar ruta si cambia FRA
  SIZE 100M
  AUTOEXTEND ON NEXT 10M MAXSIZE 1G;
