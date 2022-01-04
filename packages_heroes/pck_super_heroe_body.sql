--------------------------------------------------------
-- Archivo creado  - lunes-enero-03-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body PCK_SUPER_HEROE
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "BASTIAN_1"."PCK_SUPER_HEROE" AS
    PROCEDURE SP_GUARDAR_SUPER_HEROE(p_identidad_secreta in varchar2, p_nombre_super_heroe in varchar2, p_nivel IN number) is
    BEGIN
        INSERT INTO SUPER_HEROE VALUES(seq_id_heroe.nextval, p_identidad_secreta, p_nombre_super_heroe, sysdate, p_nivel);
    END SP_GUARDAR_SUPER_HEROE;


    PROCEDURE SP_GUARDAR_VILLANO(p_identidad_secreta in varchar2, p_nombre_super_heroe in varchar2, p_nivel IN number) is
    BEGIN
        INSERT INTO SUPER_HEROE VALUES(seq_id_heroe.nextval, p_identidad_secreta, p_nombre_super_heroe, sysdate, p_nivel);
    END SP_GUARDAR_VILLANO;


    PROCEDURE SP_LIMPIAR_TABLA(P_ID_SUPER_HEROE IN number) IS
    BEGIN 
        EXECUTE IMMEDIATE 'delete from SUPER_HEROE where ID_SUPER_HEROE = :variable1 ' using p_id_super_heroe ;
    END SP_LIMPIAR_TABLA;

    FUNCTION FN_CONOCER_TRAJE(P_IDENTIDAD_SECRETA in varchar2) return varchar2 IS
    v_nombre varchar2(200);
    BEGIN
        SELECT 
            identidad_secreta
        into
            v_nombre
        from super_heroe
        where identidad_secreta = p_identidad_secreta;
        return v_nombre;
    END FN_CONOCER_TRAJE;



    FUNCTION FN_CONOCER_NIVEL_MEJORADO(p_poder in number, p_fecha in date) return number is
    v_antiguedad number;
    v_nuevo_poder number;
    BEGIN
        v_antiguedad := TRUNC((months_between(sysdate, p_fecha)/12));
        v_nuevo_poder := v_antiguedad * p_poder;
        return v_nuevo_poder;
    END FN_CONOCER_NIVEL_MEJORADO;
END PCK_SUPER_HEROE; 


/
