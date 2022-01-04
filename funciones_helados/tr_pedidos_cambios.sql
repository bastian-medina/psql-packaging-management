--------------------------------------------------------
-- Archivo creado  - lunes-enero-03-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger PEDIDOS_TRG_CAMBIOS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "BASTIAN_2"."PEDIDOS_TRG_CAMBIOS" 
    before update on pedido
    begin
        INSERT INTO logVenta values(SEQ_LOGVENTA.nextval, 'Vendido', 'pcr_TotalizarPedido', 'Pedido', 1, SYSTIMESTAMP, USER);
end pedidos_trg_cambios;
/
ALTER TRIGGER "BASTIAN_2"."PEDIDOS_TRG_CAMBIOS" ENABLE;
