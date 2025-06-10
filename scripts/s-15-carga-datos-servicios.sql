-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                             ║
-- ║                 Sánchez Sánchez Santiago                              ║
-- ║ @Fecha creación: 10/06/2025                                           ║
-- ║ @Descripción:    Carga inicial de datos del módulo de servicios       ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

-- Deshabilitar generación de REDO para carga inicial (mejora rendimiento)
ALTER SYSTEM SET deferred_segment_creation = FALSE;
ALTER TABLE STATUS_SERVICIO NOLOGGING;
ALTER TABLE SERVICIO NOLOGGING;
ALTER TABLE SERVICIO_CONFIRMADO NOLOGGING;
ALTER TABLE CALIFICACION_SERVICIO NOLOGGING;
ALTER TABLE DEPOSITO NOLOGGING;
ALTER TABLE EVIDENCIA NOLOGGING;
ALTER TABLE HISTORICO_STATUS_SERVICIO NOLOGGING;
ALTER TABLE PAGO_SERVICIO NOLOGGING;

-- Cargar datos en STATUS_SERVICIO: inserta los posibles estados de servicio
INSERT INTO STATUS_SERVICIO (STATUS_SERVICIO_ID, FECHA_STATUS_SERVICIO, CLAVE) VALUES (1, NULL, 'SOLICITADO');
INSERT INTO STATUS_SERVICIO (STATUS_SERVICIO_ID, FECHA_STATUS_SERVICIO, CLAVE) VALUES (2, NULL, 'COTIZADO');
INSERT INTO STATUS_SERVICIO (STATUS_SERVICIO_ID, FECHA_STATUS_SERVICIO, CLAVE) VALUES (3, NULL, 'ACEPTADO');
INSERT INTO STATUS_SERVICIO (STATUS_SERVICIO_ID, FECHA_STATUS_SERVICIO, CLAVE) VALUES (4, NULL, 'RECHAZADO');
INSERT INTO STATUS_SERVICIO (STATUS_SERVICIO_ID, FECHA_STATUS_SERVICIO, CLAVE) VALUES (5, NULL, 'EN_PROCESO');
INSERT INTO STATUS_SERVICIO (STATUS_SERVICIO_ID, FECHA_STATUS_SERVICIO, CLAVE) VALUES (6, NULL, 'TERMINADO');
INSERT INTO STATUS_SERVICIO (STATUS_SERVICIO_ID, FECHA_STATUS_SERVICIO, CLAVE) VALUES (7, NULL, 'CANCELADO');
INSERT INTO STATUS_SERVICIO (STATUS_SERVICIO_ID, FECHA_STATUS_SERVICIO, CLAVE) VALUES (8, NULL, 'PAGADO');
COMMIT;

-- Cargar datos en SERVICIO (2000 registros): genera servicios con histórico, confirmación, calificaciones, depósitos, pagos y evidencias
DECLARE
  v_blob           BLOB := EMPTY_BLOB(); -- valor BLOB para documentos y evidencias
  v_status         NUMBER;               -- estado aleatorio para cada servicio
  v_fecha_servicio DATE;                 -- fecha aleatoria dentro de 2025
BEGIN
  -- Bucle principal para crear registros de servicios
  FOR i IN 1..2000 LOOP
    -- Determinar estado y fecha del servicio
    v_status := MOD(i,8) + 1;
    v_fecha_servicio := TO_DATE('2025-01-01', 'YYYY-MM-DD') + MOD(i,365);
    
    -- Insertar en tabla SERVICIO
    INSERT INTO SERVICIO (
      SERVICIO_ID, FECHA_SERVICIO, DESCRIPCION, DOCUMENTO,
      TARJETA_ID_FK, PROVEEDOR_SERVICIO_ID_FK, STATUS_SERVICIO_ID
    ) VALUES (
      i,
      v_fecha_servicio,
      'Descripción del servicio '||i||' de tipo '||
      CASE MOD(i,5)+1
        WHEN 1 THEN 'Plomería'
        WHEN 2 THEN 'Electricidad'
        WHEN 3 THEN 'Albañilería'
        WHEN 4 THEN 'Pintura'
        WHEN 5 THEN 'Carpintería'
      END,
      CASE WHEN MOD(i,3)=0 THEN v_blob ELSE NULL END,
      MOD(i,2000)+1,
      MOD(i,1000)+1,
      v_status
    );
    
    -- Insertar histórico de status para cada servicio
    FOR j IN 1..MOD(i,5)+1 LOOP
      INSERT INTO HISTORICO_STATUS_SERVICIO (
        HISTORICO_STATUS_SERVICIO_ID, FECHA_STATUS, STATUS_SERVICIO_ID, SERVICIO_ID
      ) VALUES (
        (i-1)*5 + j,
        v_fecha_servicio - MOD(j,3),
        j,
        i
      );
    END LOOP;
    
    -- Si el servicio está aceptado o más avanzado, registrar confirmación
    IF v_status > 2 THEN
      INSERT INTO SERVICIO_CONFIRMADO (
        SERVICIO_ID, PRECIO, INSTRUCCIONES, MESUALIDADES, DOCUMENTO
      ) VALUES (
        i,
        FLOOR(DBMS_RANDOM.VALUE(100,5000)),
        'Instrucciones para el servicio '||i,
        CASE WHEN MOD(i,4)=0 THEN FLOOR(DBMS_RANDOM.VALUE(3,12)) ELSE NULL END,
        CASE WHEN MOD(i,3)=0 THEN v_blob ELSE NULL END
      );
      
      -- Si el servicio está terminado o cancelado, insertar calificación
      IF v_status >= 6 THEN
        INSERT INTO CALIFICACION_SERVICIO (
          SERVICIO_ID, COMENTARIO, CALIFICACION
        ) VALUES (
          i,
          CASE MOD(i,5)
            WHEN 0 THEN 'Excelente servicio'
            WHEN 1 THEN 'Buen servicio'
            WHEN 2 THEN 'Servicio regular'
            WHEN 3 THEN 'Podría mejorar'
            ELSE 'No cumplió expectativas'
          END,
          CASE MOD(i,5)
            WHEN 0 THEN 5 WHEN 1 THEN 4 WHEN 2 THEN 3 WHEN 3 THEN 2 ELSE 1 END
        );
      END IF;
      
      -- Si el servicio se pagó, registrar depósito y pagos mensuales
      IF v_status = 8 THEN
        -- Depósito inicial
        INSERT INTO DEPOSITO (
          SERVICIO_ID, IMPORTE, FECHA_DEPOSITO, COMPROBANTE
        ) VALUES (
          i,
          FLOOR(DBMS_RANDOM.VALUE(100,5000)),
          v_fecha_servicio + MOD(i,7),
          v_blob
        );
        
        -- Pagos mensuales según plazos
        DECLARE
          v_meses          NUMBER := FLOOR(DBMS_RANDOM.VALUE(1,6));
          v_importe_total  NUMBER := FLOOR(DBMS_RANDOM.VALUE(100,5000));
          v_importe_pago   NUMBER := ROUND(v_importe_total / v_meses, 2);
        BEGIN
          FOR k IN 1..v_meses LOOP
            INSERT INTO PAGO_SERVICIO (
              NUM_PAGO, SERVICIO_ID, FECHA_PAGO, IMPORTE, COMISION
            ) VALUES (
              k,
              i,
              ADD_MONTHS(v_fecha_servicio, k),
              v_importe_pago,
              ROUND(v_importe_pago * 0.05, 2)
            );
          END LOOP;
        END;
      END IF;
    END IF;
    
    -- Insertar evidencias para servicios completados
    IF v_status >= 6 THEN
      DECLARE
        v_num_evidencias NUMBER := MOD(i,5) + 1;
      BEGIN
        FOR m IN 1..v_num_evidencias LOOP
          INSERT INTO EVIDENCIA (
            EVIDENCIA_ID, NUM_CONSECUTIVO, IMAGEN, DESCRIPCION, SERVICIO_ID
          ) VALUES (
            (i-1)*5 + m,
            m,
            v_blob,
            'Evidencia '||m||' del servicio '||i,
            i
          );
        END LOOP;
      END;
    END IF;
    
    -- Commit cada 100 registros para evitar sobrecarga de memoria
    IF MOD(i,100)=0 THEN
      COMMIT;
    END IF;
  END LOOP;
  COMMIT; -- Commit final después del bucle
END;
/

-- Volver a habilitar generación de REDO tras la carga de datos
ALTER SYSTEM SET deferred_segment_creation = TRUE;
ALTER TABLE STATUS_SERVICIO LOGGING;
ALTER TABLE SERVICIO LOGGING;
ALTER TABLE SERVICIO_CONFIRMADO LOGGING;
ALTER TABLE CALIFICACION_SERVICIO LOGGING;
ALTER TABLE DEPOSITO LOGGING;
ALTER TABLE EVIDENCIA LOGGING;
ALTER TABLE HISTORICO_STATUS_SERVICIO LOGGING;
ALTER TABLE PAGO_SERVICIO LOGGING;
