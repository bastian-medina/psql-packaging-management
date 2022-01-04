VAR b_min_emp NUMBER

VAR b_max_emp NUMBER

EXEC :b_min_emp:=100

EXEC :b_max_emp:=104

DECLARE

TYPE tipo_tabla_emp IS TABLE OF

         employees%ROWTYPE 

         INDEX BY PLS_INTEGER;

tabla_emp tipo_tabla_emp;

v_ind     NUMBER(3):=1; 

BEGIN

 FOR i IN :b_min_emp .. :b_max_emp

 LOOP

   SELECT * 

     INTO tabla_emp(v_ind) 

      FROM employees

    WHERE employee_id = i;

   v_ind := v_ind +1;

 END LOOP;

 FOR i IN tabla_emp.FIRST .. tabla_emp.LAST 

 LOOP

    DBMS_OUTPUT.PUT_LINE('Fila N° ' || i || ' de la tabla INDEX BY. Apellido: ' || tabla_emp(i).last_name || ' Salario: ' || tabla_emp(i).salary);

 END LOOP;

END;

select * from cliente;