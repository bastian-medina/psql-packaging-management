--------------------------------------------------------
-- Archivo creado  - lunes-enero-03-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure PCR_REGISTRARLOGERROR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE NONEDITIONABLE PROCEDURE "BASTIAN_2"."PCR_REGISTRARLOGERROR" (p_funcion in varchar2, p_codigo in varchar2, p_error in varchar2) is
BEGIN
    INSERT INTO LogError values(seq_LogError.nextval, p_funcion, p_codigo, p_error,sysdate,user);
END pcr_registrarLogError;

/
