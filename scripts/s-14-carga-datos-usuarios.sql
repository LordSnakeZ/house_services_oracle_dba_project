-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                             ║
-- ║                 Sánchez Sánchez Santiago                              ║
-- ║ @Fecha creación: 10/06/2025                                           ║
-- ║ @Descripción:    Carga inicial de datos del módulo de usuarios        ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

-- ---------------------------------------------------
-- Sección: Configuración inicial
-- ---------------------------------------------------
-- Se deshabilita la creación diferida de segmentos para evitar REDO
ALTER SYSTEM SET deferred_segment_creation = FALSE;

-- Se pone en NOLOGGING las tablas para acelerar la carga de datos
ALTER TABLE BANCO NOLOGGING;
ALTER TABLE CLIENTE NOLOGGING;
ALTER TABLE ENTIDAD_NACIMIENTO NOLOGGING;
ALTER TABLE NIVEL_ESTUDIO NOLOGGING;
ALTER TABLE PROVEEDOR NOLOGGING;
ALTER TABLE TIPO_SERVICIO NOLOGGING;
ALTER TABLE PROVEEDOR_SERVICIO NOLOGGING;
ALTER TABLE COMPROBANTE_EXP NOLOGGING;
ALTER TABLE CUENTA_BANCARIA NOLOGGING;
ALTER TABLE EMPRESA NOLOGGING;
ALTER TABLE PERSONA NOLOGGING;
ALTER TABLE TARJETA NOLOGGING;

-- ---------------------------------------------------
-- Sección: Inserción de datos maestros
-- ---------------------------------------------------
-- 1. Bancos
INSERT INTO BANCO (BANCO_ID, NOMBRE) VALUES (1, 'BBVA Bancomer');
INSERT INTO BANCO (BANCO_ID, NOMBRE) VALUES (2, 'Banamex');
INSERT INTO BANCO (BANCO_ID, NOMBRE) VALUES (3, 'Santander');
INSERT INTO BANCO (BANCO_ID, NOMBRE) VALUES (4, 'HSBC');
INSERT INTO BANCO (BANCO_ID, NOMBRE) VALUES (5, 'Banorte');
COMMIT;

-- 2. Entidades de nacimiento
INSERT INTO ENTIDAD_NACIMIENTO (ENTIDAD_NACIMIENTO_ID, NOMBRE) VALUES (1, 'Ciudad de México');
INSERT INTO ENTIDAD_NACIMIENTO (ENTIDAD_NACIMIENTO_ID, NOMBRE) VALUES (2, 'Estado de México');
INSERT INTO ENTIDAD_NACIMIENTO (ENTIDAD_NACIMIENTO_ID, NOMBRE) VALUES (3, 'Jalisco');
INSERT INTO ENTIDAD_NACIMIENTO (ENTIDAD_NACIMIENTO_ID, NOMBRE) VALUES (4, 'Nuevo León');
INSERT INTO ENTIDAD_NACIMIENTO (ENTIDAD_NACIMIENTO_ID, NOMBRE) VALUES (5, 'Puebla');
COMMIT;

-- 3. Niveles de estudio
INSERT INTO NIVEL_ESTUDIO (NIVEL_ESTUDIO_ID, NOMBRE) VALUES (1, 'Primaria');
INSERT INTO NIVEL_ESTUDIO (NIVEL_ESTUDIO_ID, NOMBRE) VALUES (2, 'Secundaria');
INSERT INTO NIVEL_ESTUDIO (NIVEL_ESTUDIO_ID, NOMBRE) VALUES (3, 'Preparatoria');
INSERT INTO NIVEL_ESTUDIO (NIVEL_ESTUDIO_ID, NOMBRE) VALUES (4, 'Técnico');
INSERT INTO NIVEL_ESTUDIO (NIVEL_ESTUDIO_ID, NOMBRE) VALUES (5, 'Licenciatura');
INSERT INTO NIVEL_ESTUDIO (NIVEL_ESTUDIO_ID, NOMBRE) VALUES (6, 'Maestría');
INSERT INTO NIVEL_ESTUDIO (NIVEL_ESTUDIO_ID, NOMBRE) VALUES (7, 'Doctorado');
COMMIT;

-- 4. Tipos de servicio
INSERT INTO TIPO_SERVICIO (TIPO_SERVICIO_ID, NOMBRE_SERVICIO, DESCRIPCION)
  VALUES (1, 'PLOM', 'Plomería');
INSERT INTO TIPO_SERVICIO (TIPO_SERVICIO_ID, NOMBRE_SERVICIO, DESCRIPCION)
  VALUES (2, 'ELEC', 'Electricidad');
INSERT INTO TIPO_SERVICIO (TIPO_SERVICIO_ID, NOMBRE_SERVICIO, DESCRIPCION)
  VALUES (3, 'ALBA', 'Albañilería');
INSERT INTO TIPO_SERVICIO (TIPO_SERVICIO_ID, NOMBRE_SERVICIO, DESCRIPCION)
  VALUES (4, 'PINT', 'Pintura');
INSERT INTO TIPO_SERVICIO (TIPO_SERVICIO_ID, NOMBRE_SERVICIO, DESCRIPCION)
  VALUES (5, 'CARP', 'Carpintería');
COMMIT;

-- ---------------------------------------------------
-- Sección: Carga masiva de datos de clientes
-- ---------------------------------------------------
DECLARE
  v_blob BLOB := EMPTY_BLOB();
BEGIN
  FOR i IN 1..1000 LOOP
    -- Cliente persona
    INSERT INTO CLIENTE (
      CLIENTE_ID, TIPO, NOMBRE_USUARIO, PASSWORD,
      FECHA_REGISTRO, EMAIL_USUARIO, TELEFONO, DIRECCION
    ) VALUES (
      i, 'P', 'user_p_'||i, DBMS_RANDOM.STRING('A', 10),
      SYSDATE-365, 'user_p_'||i||'@mail.com',
      '55'||LPAD(FLOOR(DBMS_RANDOM.VALUE(1000,9999)),4),
      'Calle '||i||', Col. Centro'
    );
    -- Cliente empresa
    INSERT INTO CLIENTE (
      CLIENTE_ID, TIPO, NOMBRE_USUARIO, PASSWORD,
      FECHA_REGISTRO, EMAIL_USUARIO, TELEFONO, DIRECCION
    ) VALUES (
      i+1000, 'E', 'user_e_'||i, DBMS_RANDOM.STRING('A', 10),
      SYSDATE-365, 'user_e_'||i||'@mail.com',
      '55'||LPAD(FLOOR(DBMS_RANDOM.VALUE(1000,9999)),4),
      'Av. Empresa '||i||', Col. Industrial'
    );
  END LOOP;
  COMMIT;
END;
/

-- ---------------------------------------------------
-- Sección: Datos de persona y empresa
-- ---------------------------------------------------
DECLARE
  v_blob BLOB := EMPTY_BLOB();
BEGIN
  FOR i IN 1..1000 LOOP
    -- Tabla PERSONA
    INSERT INTO PERSONA (
      CLIENTE_ID, NOMBRE, FOTO, CURP, F_NACIMIENTO
    ) VALUES (
      i, 'Persona '||i, v_blob,
      'CURP'||LPAD(i,4,'0')||'HDFRNS00',
      TO_DATE('1980-01-01','YYYY-MM-DD')+i
    );
    -- Tabla EMPRESA
    INSERT INTO EMPRESA (
      CLIENTE_ID, NOMBRE_EMPRESA, DESCRIPCION, LOGOTIPO, NUM_EMPLEADOS
    ) VALUES (
      i+1000, 'Empresa '||i, 'Descripción empresa '||i,
      v_blob, FLOOR(DBMS_RANDOM.VALUE(5,500))
    );
  END LOOP;
  COMMIT;
END;
/

-- ---------------------------------------------------
-- Sección: Proveedores y servicios asociados
-- ---------------------------------------------------
declare
  v_blob_foto BLOB := EMPTY_BLOB();
  v_blob_id   BLOB := EMPTY_BLOB();
  v_blob_dom  BLOB := EMPTY_BLOB();
begin
  -- Proveedores
  FOR i IN 1..500 LOOP
    INSERT INTO PROVEEDOR (
      PROVEEDOR_ID, NOMBRE, AP_PATERNO, AP_MATERNO,
      FOTO, F_NACIMIENTO, DIRECCION, EMAIL,
      TEL_MOVIL, TEL_CASA, IDENTIFICACION, C_DOMICILIO,
      ENTIDAD_NACIMIENTO_ID, NIVEL_ESTUDIO_ID, PROV_REPRESENTANTE_ID
    ) VALUES (
      i, 'Proveedor'||i, 'ApPaterno'||i, 'ApMaterno'||i,
      v_blob_foto, TO_DATE('1980-01-01','YYYY-MM-DD')+i,
      'Calle Proveedor '||i||', Col. Centro', 'proveedor'||i||'@mail.com',
      '55'||LPAD(FLOOR(DBMS_RANDOM.VALUE(1000,9999)),4),
      '55'||LPAD(FLOOR(DBMS_RANDOM.VALUE(1000,9999)),4),
      v_blob_id, v_blob_dom, MOD(i,5)+1, MOD(i,7)+1,
      CASE WHEN i>10 THEN MOD(i,10)+1 ELSE NULL END
    );
  END LOOP;
  COMMIT;
end;
/

-- Insertar relaciones proveedor - servicio
BEGIN
  FOR i IN 1..1000 LOOP
    INSERT INTO PROVEEDOR_SERVICIO (
      PROVEEDOR_SERVICIO_ID, EXPERIENCIA,
      PROVEEDOR_ID, TIPO_SERVICIO_ID
    ) VALUES (
      i, FLOOR(DBMS_RANDOM.VALUE(1,20)),
      MOD(i,500)+1, MOD(i,5)+1
    );
  END LOOP;
  COMMIT;
END;
/

-- ---------------------------------------------------
-- Sección: Comprobantes, cuentas y tarjetas
-- ---------------------------------------------------
begin
  -- Comprobantes de experiencia
  FOR i IN 1..500 LOOP
    INSERT INTO COMPROBANTE_EXP (
      CONPROBANTE_EXP_ID, DOCUMENTO_EXP,
      PROVEEDOR_SERVICIO_ID
    ) VALUES (i, EMPTY_BLOB(), i);
  END LOOP;
  COMMIT;
END;
/

BEGIN
  -- Cuentas bancarias
  FOR i IN 1..500 LOOP
    INSERT INTO CUENTA_BANCARIA (
      CUENTA_BANCARIA_ID, BANCO_ID,
      CLABE, PROVEEDOR_ID
    ) VALUES (
      i, MOD(i,5)+1,
      123456789012345678 + i,
      MOD(i,500)+1
    );
  END LOOP;
  COMMIT;
END;
/

BEGIN
  -- Tarjetas de cliente
  FOR i IN 1..2000 LOOP
    INSERT INTO TARJETA (
      TARJETA_ID, NUMERO,
      ANIO_EXP, MES_EXP,
      NUM_SEGURIDAD, CLIENTE_ID, BANCO_ID
    ) VALUES (
      i, 1234567890 + i,
      25 + MOD(i,5), MOD(i,12)+1,
      MOD(i,900)+100,
      MOD(i,2000)+1, MOD(i,5)+1
    );
  END LOOP;
  COMMIT;
END;
/

-- ---------------------------------------------------
-- Sección: Restaurar configuración de logging
-- ---------------------------------------------------
ALTER SYSTEM SET deferred_segment_creation = TRUE;
ALTER TABLE BANCO LOGGING;
ALTER TABLE CLIENTE LOGGING;
ALTER TABLE ENTIDAD_NACIMIENTO LOGGING;
ALTER TABLE NIVEL_ESTUDIO LOGGING;
ALTER TABLE PROVEEDOR LOGGING;
ALTER TABLE TIPO_SERVICIO LOGGING;
ALTER TABLE PROVEEDOR_SERVICIO LOGGING;
ALTER TABLE COMPROBANTE_EXP LOGGING;
ALTER TABLE CUENTA_BANCARIA LOGGING;
ALTER TABLE EMPRESA LOGGING;
ALTER TABLE PERSONA LOGGING;
ALTER TABLE TARJETA LOGGING;
