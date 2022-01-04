-- LOOP BASICO
DECLARE

   v_numero NUMBER(2);

BEGIN

v_numero := &inicio;

   LOOP

       DBMS_OUTPUT.PUT_LINE('a las : ' ||v_numero);

       v_numero := v_numero +1;

       EXIT WHEN v_numero = 99;

   END LOOP;

END;









--FOR BASICO
DECLARE

   --v_numero NUMBER(2);

BEGIN

   --v_numero := &inicio;


       FOR i IN /*REVERSE*/ 1 .. 99 LOOP

           dbms_output.put_line('foR a las : ' ||i);

       END LOOP;

END;







-- WHILE BASICO
DECLARE

   v_numero NUMBER(4) := 1;

BEGIN

   WHILE v_numero < 999 LOOP

       DBMS_OUTPUT.PUT_LINE('--- '||v_numero);

       v_numero := v_numero + 3;

   end Loop;

END;