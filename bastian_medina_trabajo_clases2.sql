VAR b_porc_aumento NUMBER
EXEC :b_porc_aumento:=1.25;

DECLARE

TYPE tipo_reg_empleado IS RECORD
(sal_prom NUMBER(7),
 id_emp_min NUMBER(3),
 id_emp_max NUMBER(3));
 
reg_empleado  tipo_reg_empleado;

v_tot_emp_act NUMBER(3):=0;

BEGIN

  SELECT 
        ROUND(AVG(salary)),
        MIN(employee_id), 
        MAX(employee_id)
    INTO 
        reg_empleado
  FROM employees; 
    
    
   FOR i IN reg_empleado.id_emp_min .. reg_empleado.id_emp_max 
   LOOP
       UPDATE registro_promedios_mensuales
          SET salario_promedio=ROUND(salario_promedio * :b_porc_aumento)
        WHERE salario_promedio >= reg_empleado.sal_prom;
        IF SQL%ROWCOUNT > 0 THEN
           v_tot_emp_act:=v_tot_emp_act+1;
        END IF;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('Total de empleados actualizados: ' || v_tot_emp_act);
END;

