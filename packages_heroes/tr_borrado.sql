--------------------------------------------------------
-- Archivo creado  - lunes-enero-03-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger TR_BORRADO
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "BASTIAN_1"."TR_BORRADO" 
    before delete on SUPER_HEROE
    BEGIN

        INSERT INTO tabla_respaldo values(user, sysdate);

    END TR_BORRADO;
/
ALTER TRIGGER "BASTIAN_1"."TR_BORRADO" ENABLE;
