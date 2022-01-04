--TRABAJO EN CLASES:

/* LLENADO DE UN BUS

MAX 45 PASAJEROS

DETERMINAR NIVELES:

PREMIUM -> 1 AL 5

GOLD -> 6 AL 26

FRECUENTE -> 27 AL 35

BASICO -> DESDE 36 


ADEMAS VALIDAR PASILLO O VENTANA 

-----------------
| 1  2      3  4|             
| 5  6      7  8|
| 9 10     11 12|
|13 14     15 16|
|17 18     19 20|
|21 22     23 24|
|25 26     27 28|
|29 30     31 32|
|33 34     35 36|
|37 38     39 40|
|41 42     43 44|
|43             |  
-----------------*/





DECLARE

    v_numero_asiento number(2) := &numero_asiento;
    v_tipo_asiento varchar(30);
    v_ventana varchar(30);

BEGIN
    
    -- Tipo de asiento según rango
    if v_numero_asiento > 45 or v_numero_asiento < 1 then
        v_tipo_asiento := 'no existe';
    elsif v_numero_asiento between 1 and 5 then
        v_tipo_asiento := 'Asiento Premium';
    elsif v_numero_asiento between 6 and 26 then
        v_tipo_asiento := 'Asiento Gold';
    elsif v_numero_asiento between 27 and 35 then
        v_tipo_asiento := 'Asiento Frecuente';
    elsif v_numero_asiento between 36 and 45 then
        v_tipo_asiento := 'Asiento Básico';
    end if;
    
    --ventana o no
    /* 
    toda ventana de la derecha es multiplo de 4*n, por lo que al dividirla entre 4, el resto da 0
    toda ventana de la izquierda es multiplo de 4*n+1, por lo que al dividirla entre 4, el resto da 1
    */
    if (mod(v_numero_asiento, 4) = 0) or (mod(v_numero_asiento, 4 ) = 1) then
        v_ventana := 'Ventana';
    elsif (mod(v_numero_asiento, 4) = 2) or (mod(v_numero_asiento, 4) = 3) then
        v_ventana := 'Pasillo';
    else
        v_ventana :='ERROR';
    end if;
        
    -- informacion de asiento
    dbms_output.put_line('Informacion Asiento');    
    dbms_output.put_line('');    
    dbms_output.put_line('Numero de asiento: ' || v_numero_asiento);
    dbms_output.put_line('Tipo de asiento: ' || v_tipo_asiento);
    dbms_output.put_line('Tipo Vista: ' || v_ventana);

END;

/*
DECLARE

   v_ubicacion VARCHAR2(10);

   v_numero_boleto NUMBER(2);

BEGIN

   v_numero_boleto := &ticket;

   IF v_numero_boleto > 0 AND v_numero_boleto < 6 THEN

    DBMS_OUTPUT.PUT_LINE('PREMIUM');

   ELSIF v_numero_boleto > 5 AND v_numero_boleto < 27 THEN

    DBMS_OUTPUT.PUT_LINE('GOLD');

   ELSIF v_numero_boleto > 27 AND v_numero_boleto < 36 THEN

    DBMS_OUTPUT.PUT_LINE('FRECUENTE');

   ELSE

    DBMS_OUTPUT.PUT_LINE('BASICO');

   END IF;


   v_ubicacion :=

       CASE

           WHEN v_numero_boleto IN(1,5,9,13,17) THEN 'VENTANA'

           WHEN v_numero_boleto IN(2,6,10,14,18) THEN 'PASILLO'


           WHEN v_numero_boleto IN(3,7,11,15,19) THEN 'PASILLO'

           WHEN v_numero_boleto IN(4,8,12,16,20) THEN 'VENTANA'

       END;

   DBMS_OUTPUT.PUT_LINE('Sector: '||v_ubicacion);

END;
*/