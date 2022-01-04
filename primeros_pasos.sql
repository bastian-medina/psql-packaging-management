DECLARE

    v_nombre varchar2(250) :='sin asignar';
    v_sueldo EMPLOYEES.SALARY%type;
    
BEGIN

    select
        first_name, salary
    into
        v_nombre, v_sueldo
    from employees
    where employee_id = &buscarUd;
    
    DBMS_OUTPUT.PUT_LINE(v_nombre || ' gana ' || v_sueldo);
    
    
exception
    when NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('>>' || v_nombre);
        
END;