--------------------------------------------------------
-- Archivo creado  - lunes-enero-03-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PCK_HELADOS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "BASTIAN_2"."PCK_HELADOS" AS
    PROCEDURE PRC_GENERARPEDIDO(V_RUT IN VARCHAR2);
    PROCEDURE PRC_AGREGARHELADO(V_HELADO_CODE IN VARCHAR2, V_RUT IN VARCHAR2);
    PROCEDURE PRC_TOTALIZARPEDIDO(V_RUT IN VARCHAR2);
    PROCEDURE PRC_LIMPIATABLA;
END PCK_HELADOS;

/
