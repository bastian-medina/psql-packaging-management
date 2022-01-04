--------------------------------------------------------
-- Archivo creado  - lunes-enero-03-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function FN_VALIDARRUT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE FUNCTION "BASTIAN_2"."FN_VALIDARRUT" (p_rut_entrada in varchar2) return number is
    p_id_cliente varchar2(100);
BEGIN

    SELECT
        cliente_id
    INTO
        p_id_cliente
    FROM cliente
    where rut = p_rut_entrada;

    return p_id_cliente;
END fn_ValidarRut;

/
