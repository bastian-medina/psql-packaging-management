CREATE TABLE SUPER_HEROE
(
    id_super_heroe number,
    identidad_secreta varchar2(20),
    nombre_super_heroe varchar2(20),
    fecha_incorporacion date,
    nivel_poder number
);

create table tabla_respaldo
(
    usuario varchar2(200),
    dia_borrado date
);

--drop table tabla_respaldo;
CREATE SEQUENCE SEQ_ID_HEROE
 	START WITH     1
 	INCREMENT BY   1 
 	NOCYCLE;


CREATE OR REPLACE PACKAGE PCK_SUPER_HEROE AS
    PROCEDURE SP_GUARDAR_SUPER_HEROE(p_identidad_secreta in varchar2, p_nombre_super_heroe in varchar2, p_nivel IN number);
    PROCEDURE SP_GUARDAR_VILLANO(p_identidad_secreta in varchar2, p_nombre_super_heroe in varchar2, p_nivel IN number); 
    PROCEDURE SP_LIMPIAR_TABLA(P_ID_SUPER_HEROE IN number);
    
    FUNCTION FN_CONOCER_TRAJE(P_IDENTIDAD_SECRETA in varchar2) return varchar2;
    FUNCTION FN_CONOCER_NIVEL_MEJORADO(p_poder in number, p_fecha in date) return number;
END PCK_SUPER_HEROE;

create or replace trigger tr_borrado
    before delete on SUPER_HEROE
    BEGIN
    
        INSERT INTO tabla_respaldo values(user, sysdate);
    
    END TR_BORRADO;
    
    
CREATE OR REPLACE PACKAGE body PCK_SUPER_HEROE AS
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
        EXECUTE IMMEDIATE 'delete from SUPER_HEROE where ID_SUPER_HEROE = :peo ' using p_id_super_heroe ;
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
    
    

select
    id_super_heroe, pck_super_heroe.fn_conocer_nivel_mejorado(nivel_poder, fecha_incorporacion) as nivel_mejorado
from super_heroe;


select
    id_super_heroe, pck_super_heroe.sp_limpiar_tabla(id_super_heroe)
from super_heroe; 
    
    
delete from SUPER_HEROE where ID_SUPER_HEROE = 100;

select * 
from SUPER_HEROE;
    
select * 
from TABLA_RESPALDO;    
    
BEGIN
    pck_super_heroe.SP_GUARDAR_SUPER_HEROE('BATMAN', 'Bruce Wayne', 4);
END;

BEGIN
    pck_super_heroe.sp_limpiar_tabla(21);
END;

/*
STORAGE PROCEDURE -> FUNCIONA SOLO CON BLOQUE BEGIN/END
FUNCTION FUNCIONA -> FUNCIONA SOLO (AL PARECER) CON SELECT * FROM tabla;
*/