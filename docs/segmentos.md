
    ## 1.3.6.3 Segment–Tablespace Mapping

    The following table lists every segment created in the *House Services* schema and the tablespace where it resides.

    | Módulo   | Tipo de segmento   | Nombre del segmento          | Tablespace             |
|:---------|:-------------------|:-----------------------------|:-----------------------|
| USUARIOS | Tabla              | proveedor_seg                | tbs_proveedor          |
| USUARIOS | Objeto LOB         | proveedor_identificacion_seg | tbs_proveedor_lob      |
| USUARIOS | Objeto LOB         | proveedor_c_domicilio_seg    | tbs_proveedor_lob      |
| USUARIOS | Índice             | proveedor_indice_seg         | tbs_proveedor_indices  |
| USUARIOS | Tabla              | entidad_nacimiento_seg       | tbs_proveedor_catalogo |
| USUARIOS | Índice             | entidad_indice_seg           | tbs_proveedor_indices  |
| USUARIOS | Tabla              | nivel_estudio_seg            | tbs_proveedor_catalogo |
| USUARIOS | Índice             | nivel_estudio_indice_seg     | tbs_proveedor_indices  |
| USUARIOS | Tabla              | tipo_servicio_seg            | tbs_proveedor_catalogo |
| USUARIOS | Índice             | tipo_servicio_indice_seg     | tbs_proveedor_indices  |
| USUARIOS | Tabla              | comprobante_seg              | tbs_comprobante        |
| USUARIOS | Objeto LOB         | comprobante_doc_seg          | tbs_comprobante_lob    |
| USUARIOS | Índice             | comprobante_indice_seg       | tbs_proveedor_indices  |
| USUARIOS | Tabla              | comprobante_cuenta_seg       | tbs_cuenta_bancaria    |
| USUARIOS | Índice             | comprobante_indice_seg       | tbs_proveedor_indices  |
| USUARIOS | Tabla              | banco_seg                    | tbs_banco              |
| USUARIOS | Índice             | banco_indice_seg             | tbs_banco              |
| USUARIOS | Tabla              | cliente_seg                  | tbs_cliente            |
| USUARIOS | Índice             | cliente_indice_seg           | tbs_cliente_indices    |
| USUARIOS | Tabla              | empresa_seg                  | tbs_cliente            |
| USUARIOS | Índice             | empresa_indice_seg           | tbs_cliente_indices    |
| USUARIOS | Objeto LOB         | empresa_logotipo_seg         | tbs_cliente_lob        |
| USUARIOS | Tabla              | persona_seg                  | tbs_cliente            |
| USUARIOS | Índice             | persona_indice_seg           | tbs_cliente_indices    |
| USUARIOS | Objeto LOB         | persona_foto_seg             | tbs_cliente_lob        |
| SERVICIO | Tabla              | servicio_q1_seg              | tbs_servicio_1         |
| SERVICIO | Tabla              | servicio_q2_seg              | tbs_servicio_2         |
| SERVICIO | Índice             | servicio_indice_seg          | tbs_servicio_indices   |
| SERVICIO | Objeto LOB         | servicio_documento_seg       | tbs_servicio_lob       |
| SERVICIO | Tabla              | historico_q1_seg             | tbs_historico_1        |
| SERVICIO | Tabla              | historico_q2_seg             | tbs_historico_2        |
| SERVICIO | Índice             | historico_indice             | tbs_servicio_indices   |
