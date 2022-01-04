/*
PRUEBA 2
BASTIAN ORLANDO MEDINA AGUILERA 
PRY3131_002D

USUARIO: BASTIAN_MEDINA_PRUEBA2_002D
CONTRASENA: HOLAPRUEBA1

CREA DIRECTORIO: CREATE DIRECTORY fotografias AS 'C:\fotografias';
PERMISOS DIRECTORIO: GRANT READ ON DIRECTORY fotografias TO bastian_medina_prueba2_002D;

secuencia para errores
CREATE SEQUENCE SEQ_ERROR2
 	START WITH     1
 	INCREMENT BY   1 
 	NOCYCLE;
    
secuencia para reporte_cajas
CREATE SEQUENCE SEQ_ERROR1
 	START WITH     1
 	INCREMENT BY   1 
 	NOCYCLE;
*/

SELECT * FROM REPORTE_CAJAS;
SELECT * FROM ALUMNO;
select * from PAGO_EXTRA_DOCENTES;


DECLARE
    --cursor que me recorrerá todas las cajas 
    CURSOR cur_disc_cajas is
        select DISTINCT nombre nombre
    from caja;
    
    --cursor que me trae la informacion necesaria DE ALUMNO
    CURSOR cur_alumno(p_tipo_caja VARCHAR2) is
        SELECT
            a.rut rut,
            a.bonoescolaridad bonoescolaridad,
            a.SUELDO sueldo,
            a.CARGAS cargas,
            a.CAJA_IDCAJA id_caja,
            c.nombre  nombre_caja,
            sum(vc.PRECIOCURSO) precio_total_curso
        FROM ALUMNO a
        join alumnos_curso al
        on al.rut_alumno = a.rut
        join caja c
        on c.id_caja = a.CAJA_IDCAJA
        join version_curso vc
        on vc.id_version = al.id_version_curso
        where extract(year from vc.FECHAINICIO) = (extract(year from sysdate)-1) 
        group by a.SUELDO, a.CARGAS, a.CAJA_IDCAJA, a.rut, c.nombre, a.bonoescolaridad;
        
    --cursor que me trae le imagen PARA ACTUALIZACION DE FOTO 
    CURSOR cur_alumno_act_foto is
        SELECT 
            rut,
            imagen
        from ALUMNO FOR UPDATE;
        
    --CURSOR DE DOCENTES
    CURSOR cur_docentes is
        SELECT 
            d.RUT rut,
            d.PNOMBRE || ' ' || d.APPATERNO nombre,
            sum(c.CANTHORAS) horas,
            ac.rut_alumno 
        FROM DOCENTE d
        JOIN version_curso vc
        on d.rut = vc.docente_rut
        join curso c
        on c.id_curso = vc.curso_idcurso
        join alumnos_curso ac
        on vc.id_version = ac.id_version_curso
        group by d.PNOMBRE || ' ' || d.APPATERNO, d.RUT, ac.rut_alumno;
        
    -- variables que almacenarán las fotos, su ruta y su nombre
    v_nombre_foto VARCHAR2(20);
    v_blob blob;
    v_bfile bfile;
    v_valida_archivo number;
    

    --variables adicionales
    v_bono_ayuda number;
    v_factor_bono number;
    v_bono_caja number;
    v_bono_escolaridad number := 0;
    
    --inserciones de informacion de caja
    v_total_caja number := 0;
    
    -- valores para insercion de bono profesor
    v_contador_alumnos number;
    v_total_pago number;

BEGIN

    -- PARTE 1
    -- BONOS CAJA COMPENSACION, BONO ESCOLARIDAD Y PAGOS DE ALUMNOS/TRABAJADORES

    for caja in cur_disc_cajas loop
        v_total_caja := 0;
        
        BEGIN
                for alumno in cur_alumno(caja.nombre) loop
                    
                    v_bono_escolaridad :=0;
                    
                    -- calculo bono de caja de compensacion
                    select 
                        (c.descuento/100)*alumno.precio_total_curso
                    into
                        v_bono_caja
                    from caja c
                    join alumno a
                    on c.id_caja = a.caja_idcaja
                    where a.rut = alumno.rut;
                    
                    
                    -- calculo bono escolaridad
                    if alumno.sueldo between 326500 and 350000 then 
                        v_factor_bono := 0.3;
                    elsif alumno.sueldo between 350001 and 450000 then
                        v_factor_bono := 0.2;
                    elsif alumno.sueldo between 450001 and 550000 then
                        v_factor_bono := 0.1;
                    elsif alumno.sueldo between 550001 and 700000 then
                        v_factor_bono := 0.05;
                    else 
                        v_factor_bono := 0;
                    end if;
                    
                    v_bono_escolaridad :=(alumno.sueldo*v_factor_bono)+(alumno.cargas*5500); --por documentacion bono hijo = 5500
                    
                    --actualizo la tabla
                    if alumno.bonoescolaridad = 0 then
                        update alumno set bonoescolaridad = v_bono_escolaridad
                            where rut = alumno.rut;
                    end if;
                    
                    
                    --calculo la ayuda, que es la suma de ambos bonos calculado
                    v_bono_ayuda := v_bono_escolaridad + v_bono_caja;
                    
                    
                    --limito la ayuda, pues, es demasiado dinero y se deben cumplir los requisitos
                    if v_bono_ayuda >100000 then
                        v_bono_ayuda :=100000;
                        INSERT INTO ERRORES_PROCESO VALUES(SEQ_ERROR2.nextval, 'CALCULO BONO AYUDA', 'EL ALUMNO RUT ' || ALUMNO.RUT || ' SOBREPASA EL VALOR MAXIMO DE ASIGNACION');
                    end if;
                    
                    -- prepara los datos para la insercion en la tabla reporte_cajas
                    v_total_caja := v_total_caja + v_bono_ayuda;
            
                end loop;
            
            --insercion del reporte
                INSERT INTO REPORTE_CAJAS VALUES(SEQ_ERROR1.nextval, caja.nombre, EXTRACT(YEAR FROM SYSDATE)-1, v_total_caja);
        END;
            
    end loop;
    

    
    
    --PARTE 2
    --ACTUALIZACION DE FOTO
    for alumnoUpdate in cur_alumno_act_foto loop
    
        BEGIN
        
            v_blob := alumnoUpdate.imagen;
            v_nombre_foto := alumnoUpdate.rut || '.jpg';
            v_bfile := BFILENAME('FOTOGRAFIAS', v_nombre_foto);

            dbms_lob.fileopen(v_bfile, dbms_lob.file_readonly);
            dbms_lob.loadfromfile(v_blob, v_bfile, dbms_lob.getlength(v_bfile));
            dbms_lob.fileclose(v_bfile);

            
        EXCEPTION WHEN OTHERS THEN
            INSERT INTO ERRORES_PROCESO VALUES(SEQ_ERROR2.nextval, 'ACTUALIZAR FOTOS', 'EL ALUMNO RUT ' || ALUMNOUPDATE.RUT || ' NO SE PUDO ACTUALIZAR FOTO');
    
        END;
        
    end loop;
    
    
    
    --PARTE 3
    --PREMIO DOCENTE 
    
    for docente in cur_docentes loop
        
        select 
            count(rut_alumno)
        into
            v_contador_alumnos
        from alumnos_curso ac
        join version_curso vc
        on vc.id_version = ac.id_version_curso
        join docente d
        on d.rut = vc.docente_rut
        where d.rut = docente.rut;
        
        if v_contador_alumnos >= 15 then
            v_total_pago := docente.horas*2500;
            INSERT INTO PAGO_EXTRA_DOCENTES VALUES(docente.rut, docente.nombre, docente.horas,extract(year from sysdate)-1, v_total_pago);
        end if;
        
        
    end loop;

END;