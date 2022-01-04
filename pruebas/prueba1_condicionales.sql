-- PRUEBA1
-- BASTIAN MEDINA
-- MDY_002D


DECLARE

    --bind
    v_valor_cargo_familiar number := &valor_carga_familiar;          -- requerimiento de la prueba pide ingresar 5700*cantidad_integrantes 
    v_valor_colacion number := &valor_colacion;                      -- prueba pide que sea de 77000
    v_fecha date := &fecha;                                          -- prueba pide febrero del 2018 ('28/02/2018')
    v_valor_especializacion number := &valor_especializacion;        -- depende de la especialización y de la multiplicacion 50%, 30%, 20%, 5% segun sueldo base
                                                                     -- recomiendo utilizar 300001

    -- valores de personas
    v_rut_persona varchar2(10);
    v_anno_ingreso number;
    v_sueldo_base number;
    v_nombre_especialidad varchar2(30);
    v_grado_academ varchar2(30);
    v_nombre_salud varchar2(30);
    v_nombre_afp varchar2(30);
    v_comision number;
    
    
    -- datos de fecha
    v_annio number := extract(year from v_fecha);
    v_mes number := extract(month from v_fecha);
    v_annos_totales number;
    

    --variables que cambiarán
    v_valor_haber number(15) := 0;
    v_valor_descuento number(15) := 0;
    v_valor_liquido number(15) := 0;
    
    
    -- valor afp y salud
    v_descuento_provision_afp number(15) := 0;
    v_descuento_salud number(15) := 0;

BEGIN

    
    select
    
    e.NUMRUT_EMP,
    extract(YEAR from e.FECING_EMP),
    e.SUELDO_BASE_EMP,
    es.NOMBRE_ESPECIALIDAD,
    ag.DESC_GRADO,
    s.NOMBRE_SALUD,
    af.NOMBRE_AFP,
    sum(a.MONTO_ATENCION)
    
    into
    v_rut_persona,
    v_anno_ingreso,
    v_sueldo_base,
    v_nombre_especialidad,
    v_grado_academ,
    v_nombre_salud,
    v_nombre_afp,
    v_comision

    from empleado e
    full join especialidad es
    on es.ID_ESPECIALIDAD = e.ID_ESPECIALIDAD
    full join asig_grado ag
    on ag.id_grado = e.ID_GRADO
    full join salud s
    on s.COD_SALUD = e.COD_SALUD
    full join afp af
    on af.COD_AFP = e.COD_AFP
    full join atencion a
    on a.NUMRUT_EMP = e.NUMRUT_EMP
    full join COMISION_ATENCION ca
    on ca.NRO_ATENCION = a.NRO_ATENCION
    
    --aqui se cambia el rut del cliente
    where e.NUMRUT_EMP || '-' || e.DVRUT_EMP = '11670042-5' 
    group by e.NUMRUT_EMP, extract(YEAR from e.FECING_EMP), e.SUELDO_BASE_EMP, es.NOMBRE_ESPECIALIDAD,
             ag.DESC_GRADO, s.NOMBRE_SALUD, af.NOMBRE_AFP;

    
    --OBTENEMOS CANTIDAD DE AÑOS EN LA EMPRESA
    v_annos_totales := v_annio - v_anno_ingreso;
    
    -- ASIGNACION CARGA FAMILIAR 
    v_valor_haber := v_valor_haber + v_valor_cargo_familiar;
    v_descuento_provision_afp := v_descuento_provision_afp + v_valor_cargo_familiar;
    
    --ASIGNACION DE ESPECIALIZACION
    v_valor_haber := v_valor_haber + v_valor_especializacion;
    
    --ASIGNACION COLACION
    v_valor_haber := v_valor_haber + v_valor_colacion;
    
    --ASIGNACION DE SUELDO_BASE
    v_valor_haber := v_valor_haber + v_sueldo_base;
    v_descuento_provision_afp := v_descuento_provision_afp + v_sueldo_base;
    v_descuento_salud := v_descuento_salud + v_sueldo_base;
    
    
    --ASIGNACION DE COMISION DE ATENCIONES
    v_valor_haber := v_valor_haber + v_comision;
    v_descuento_provision_afp := v_descuento_provision_afp + v_comision;
    
    -- ASIGNACION DE COMISION POR AÑOS TRABAJADOS
    if v_annos_totales between 2 and 9 then
        v_valor_haber := v_valor_haber + v_sueldo_base*0.03;
        v_descuento_salud := v_descuento_salud + v_sueldo_base*0.03;
    elsif v_annos_totales between 10 and 12 then
        v_valor_haber := v_valor_haber + v_sueldo_base*0.06;
        v_descuento_salud := v_descuento_salud + v_sueldo_base*0.06;
    elsif v_annos_totales between 13 and 17 then
        v_valor_haber := v_valor_haber + v_sueldo_base*0.09;
        v_descuento_salud := v_descuento_salud + v_sueldo_base*0.09;
    elsif v_annos_totales between 18 and 30 then
        v_valor_haber := v_valor_haber + v_sueldo_base*0.15;
        v_descuento_salud := v_descuento_salud + v_sueldo_base*0.15;
    end if;
    
    
    -- ASIGNACION DE COMISION DE HABILITACION O GRADO
    if v_grado_academ = 'BACHILLER' THEN
        v_valor_haber := v_valor_haber + v_sueldo_base*0.1;
        v_descuento_provision_afp := v_descuento_provision_afp + v_sueldo_base*0.1;
    elsif v_grado_academ = 'MASTERS' THEN
        v_valor_haber := v_valor_haber + v_sueldo_base*0.2;
        v_descuento_provision_afp := v_descuento_provision_afp + v_sueldo_base*0.2;
    elsif v_grado_academ = 'DOCTORADO' THEN
        v_valor_haber := v_valor_haber + v_sueldo_base*0.3;
        v_descuento_provision_afp := v_descuento_provision_afp + v_sueldo_base*0.3;
    elsif v_grado_academ = 'HONORARIO' THEN
        v_valor_haber := v_valor_haber + v_sueldo_base*0.4;
        v_descuento_provision_afp := v_descuento_provision_afp + v_sueldo_base*0.4;
    end if;    
    
    
    -- ASIGNACION DE COMISION DE ESPECIALIZACION ONCOLOGIA, Geriatria, Radiologia o Laboratorio
    if v_nombre_especialidad = 'Oncologia' or v_nombre_especialidad = 'Geriatria' then
        v_valor_haber := v_valor_haber + 55000;
    elsif v_nombre_especialidad = 'Radiologia' or v_nombre_especialidad = 'Laboratorio' then
        v_valor_haber := v_valor_haber + 88000;
    end if;
    
    
    --CALCULO AFP
    if v_nombre_afp = 'CAPITAL' then
        v_descuento_provision_afp := v_descuento_provision_afp*0.10;
    elsif v_nombre_afp = 'CUPRUM' then
        v_descuento_provision_afp := v_descuento_provision_afp*0.12;
    elsif v_nombre_afp = 'HABITAT' then
        v_descuento_provision_afp := v_descuento_provision_afp*0.14;
    elsif v_nombre_afp = 'MODELO' then
        v_descuento_provision_afp := v_descuento_provision_afp*0.08;
    elsif v_nombre_afp = 'PLANVITAL' then
        v_descuento_provision_afp := v_descuento_provision_afp*0.15;
    elsif v_nombre_afp = 'PROVIDA' then
        v_descuento_provision_afp := v_descuento_provision_afp*0.13;
    end if;
    
    --CALCULO SALUD
    if v_nombre_salud = 'FONASA' then
        v_descuento_salud := v_descuento_salud*0.08;
    elsif v_nombre_salud = 'BAN MEDICA' then
        v_descuento_salud := v_descuento_salud*0.14;
    elsif v_nombre_salud = 'COLMENA' then
        v_descuento_salud := v_descuento_salud*0.07;
    elsif v_nombre_salud = 'CONSALUD' then
        v_descuento_salud := v_descuento_salud*0.11;
    elsif v_nombre_salud = 'CRUZ BLANCA' then
        v_descuento_salud := v_descuento_salud*0.13;
    elsif v_nombre_salud = 'MASVIDA' then
        v_descuento_salud := v_descuento_salud*0.14;
    elsif v_nombre_salud = 'VIDA TRES' then
        v_descuento_salud := v_descuento_salud*0.10;
    end if;
    
    -- DESCUENTO
    v_valor_descuento := v_descuento_salud + v_descuento_provision_afp;
    
    -- LIQUIDO
    v_valor_liquido := v_valor_haber - v_valor_descuento;
    

    
    --INSERSION A LA TABLA HABER_CALC_MES
    insert into HABER_CALC_MES values (v_rut_persona, v_mes, v_annio, v_sueldo_base, v_annos_totales, v_valor_cargo_familiar,
                                       v_valor_especializacion, v_valor_colacion, v_comision, v_valor_haber);
                                       
                                       
    --INSERT A LA TABLA DESCUENTO_CALC_MES
    insert into DESCUENTO_CALC_MES values (v_valor_descuento);

END;

/*
------  CREACION TABLA --------
create table DESCUENTO_CALC_MES
(DESCUENTO NUMBER);

esta tabla, necesaria para guardar el descuento, no existe, asi que la agregué
con solo un valor para realizar una inserción (muy simple)
*/





/*
--------- VERIFICACION DE DATOS -----------
SI DESEA SABER LAS SALIDAS DE LAS VARIABLES EJECUTE ESTO

    dbms_output.put_line(v_valor_cargo_familiar);
    dbms_output.put_line(v_valor_colacion);
    dbms_output.put_line(v_fecha);
    dbms_output.put_line(v_valor_especializacion);
    dbms_output.put_line(v_rut_persona);
    dbms_output.put_line(v_anno_ingreso);
    dbms_output.put_line(v_sueldo_base);
    dbms_output.put_line(v_nombre_especialidad);
    dbms_output.put_line(v_grado_academ);
    dbms_output.put_line(v_nombre_salud);
    dbms_output.put_line(v_nombre_afp );
    dbms_output.put_line(v_comision);
    dbms_output.put_line(v_annio);
    dbms_output.put_line(v_annos_totales);
    dbms_output.put_line(v_valor_haber);
    dbms_output.put_line(v_valor_descuento);
    dbms_output.put_line(v_valor_liquido);
    dbms_output.put_line(v_descuento_provision_afp);
    dbms_output.put_line(v_descuento_salud);




*/

