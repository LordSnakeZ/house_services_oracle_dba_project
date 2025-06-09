
## 1.3.6.3 Segment–Tablespace Mapping

| Module | Segment Type | Segment Name | Tablespace |
|--------|--------------|--------------|------------|
| USUARIOS | Table | proveedor_seg | tbs_proveedor |
| USUARIOS | LOB Object | proveedor_identificacion_seg | tbs_proveedor_lob |
| USUARIOS | LOB Object | proveedor_c_domicilio_seg | tbs_proveedor_lob |
| USUARIOS | Index | proveedor_indice_seg | tbs_proveedor_indices |
| USUARIOS | Table | entidad_nacimiento_seg | tbs_proveedor_catalogo |
| USUARIOS | Index | entidad_indice_seg | tbs_proveedor_indices |
| USUARIOS | Table | nivel_estudio_seg | tbs_proveedor_catalogo |
| USUARIOS | Index | nivel_estudio_indice_seg | tbs_proveedor_indices |
| USUARIOS | Table | tipo_servicio_seg | tbs_proveedor_catalogo |
| USUARIOS | Index | tipo_servicio_indice_seg | tbs_proveedor_indices |
| USUARIOS | Table | comprobante_seg | tbs_comprobante |
| USUARIOS | LOB Object | comprobante_doc_seg | tbs_comprobante_lob |
| USUARIOS | Index | comprobante_indice_seg | tbs_proveedor_indices |
| USUARIOS | Table | comprobante_cuenta_seg | tbs_cuenta_bancaria |
| USUARIOS | Index | comprobante_indice_seg | tbs_proveedor_indices |
| USUARIOS | Table | banco_seg | tbs_banco |
| USUARIOS | Index | banco_indice_seg | tbs_banco |
| USUARIOS | Table | cliente_seg | tbs_cliente |
| USUARIOS | Index | cliente_indice_seg | tbs_cliente_indices |
| USUARIOS | Table | empresa_seg | tbs_cliente |
| USUARIOS | Index | empresa_indice_seg | tbs_cliente_indices |
| USUARIOS | LOB Object | empresa_logotipo_seg | tbs_cliente_lob |
| USUARIOS | Table | persona_seg | tbs_cliente |
| USUARIOS | Index | persona_indice_seg | tbs_cliente_indices |
| USUARIOS | LOB Object | persona_foto_seg | tbs_cliente_lob |
| SERVICIO | Table | servicio_q1_seg | tbs_servicio_1 |
| SERVICIO | Table | servicio_q2_seg | tbs_servicio_2 |
| SERVICIO | Index | servicio_indice_seg | tbs_servicio_indices |
| SERVICIO | LOB Object | servicio_documento_seg | tbs_servicio_lob |
| SERVICIO | Table | historico_q1_seg | tbs_historico_1 |
| SERVICIO | Table | historico_q2_seg | tbs_historico_2 |
| SERVICIO | Index | historico_indice | tbs_servicio_indices |
