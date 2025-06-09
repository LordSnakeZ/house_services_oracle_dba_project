--@Autor:		Luis Héctor Chávez Mejía
--@Fecha de cración 	09/03/2025
--@Descripción:		Creación de una pdb

connect sys/system2 as sysdba

-- Crear una nueva PDB
create pluggable database chsabda_s2
admin user chsa_admin identified by chsa_admin
path_prefix = '/unam/bda/d17'
file_name_convert = ('/pdbseed/', '/chsabda_s2/');

prompt abrir la PDB
alter pluggable database chsabda_s2 open;
Prompt guardar el estado de la PDB
alter pluggable database chsabda_s2 save state;
