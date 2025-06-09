connect sys/system2@chsabda_s2 as sysdba;


drop tablespace TBS_PROVEEDOR including contents and datafiles cascade constraints;
drop tablespace MODULO_USUARIOS_DEFAULT_TBS including contents and datafiles cascade constraints;
drop tablespace TBS_BANCO including contents and datafiles cascade constraints;
drop tablespace TBS_MOD_USUARIO_INDICES including contents and datafiles cascade constraints;
drop tablespace TBS_PROVEEDOR_LOB including contents and datafiles cascade constraints;
drop tablespace TBS_CUENTA_BANCARIA including contents and datafiles cascade constraints;
drop tablespace TBS_COMPROBANTE including contents and datafiles cascade constraints;
drop tablespace TBS_PROVEEDOR_SERVICIO including contents and datafiles cascade constraints;
drop tablespace TBS_PROVEEDOR_CATALOGO including contents and datafiles cascade constraints;
drop tablespace TBS_SERVICIO_1 including contents and datafiles cascade constraints;
drop tablespace TBS_SERVICIO_2 including contents and datafiles cascade constraints;
drop tablespace TBS_SERVICIO_LOB including contents and datafiles cascade constraints;
drop tablespace TBS_SERVICIO_CONFIRMADO including contents and datafiles cascade constraints;
drop tablespace TBS_SERVICIO_EVIDENCIA including contents and datafiles cascade constraints;
drop tablespace TBS_PAGO_SERVICIO including contents and datafiles cascade constraints;
drop tablespace TBS_MOD_SERVICIO_INDICES including contents and datafiles cascade constraints;
drop tablespace MODULO_SERVICIO_DEFAULT_TBS including contents and datafiles cascade constraints;
drop tablespace TBS_COMPROBANTE_LOB including contents and datafiles cascade constraints;
drop tablespace TBS_CLIENTE_LOB including contents and datafiles cascade constraints;
drop tablespace TBS_SERVICIO_EVIDENCIA_LOB including contents and datafiles cascade constraints;
