--------------------------------------------------------
-- Archivo creado  - lunes-enero-03-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PCK_SUPER_HEROE
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "BASTIAN_1"."PCK_SUPER_HEROE" AS
    PROCEDURE SP_GUARDAR_SUPER_HEROE(p_identidad_secreta in varchar2, p_nombre_super_heroe in varchar2, p_nivel IN number);
    PROCEDURE SP_GUARDAR_VILLANO(p_identidad_secreta in varchar2, p_nombre_super_heroe in varchar2, p_nivel IN number); 
    PROCEDURE SP_LIMPIAR_TABLA(P_ID_SUPER_HEROE IN number);

    FUNCTION FN_CONOCER_TRAJE(P_IDENTIDAD_SECRETA in varchar2) return varchar2;
    FUNCTION FN_CONOCER_NIVEL_MEJORADO(p_poder in number, p_fecha in date) return number;
END PCK_SUPER_HEROE;

/
