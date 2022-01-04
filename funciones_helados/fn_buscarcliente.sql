--------------------------------------------------------
-- Archivo creado  - lunes-enero-03-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function FN_BUSCARCLIENTE
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE FUNCTION "BASTIAN_2"."FN_BUSCARCLIENTE" 
   (V_RUT IN VARCHAR2)
   RETURN NUMBER
IS 
    RUT_CLIENTE VARCHAR2(100);
    ID_CLIENTE NUMBER;
    CODE VARCHAR2(100);
    E_RROR VARCHAR2(500);
BEGIN
   SELECT
        RUT,
        CLIENTE_ID
   INTO
        RUT_CLIENTE,
        ID_CLIENTE
   FROM CLIENTE
   WHERE RUT = V_RUT;
   RETURN ID_CLIENTE;
END FN_BUSCARCLIENTE;

/
