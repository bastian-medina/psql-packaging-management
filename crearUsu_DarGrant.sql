alter session set "_ORACLE_SCRIPT"=true;

create user bastian_2 identified by bastian_2;
grant connect, resource to bastian_2;
GRANT UNLIMITED TABLESPACE TO bastian_2;

-- DOY PERMISOS DE LECTURA DE LA CARPETA
GRANT READ, WRITE ON DIRECTORY fotografias TO bastian_medina_prueba2_002D;

create DIRECTORY fotografias AS 'C:\FOTOGRAFIAS';
drop directory fotografias;

SELECT * FROM DBA_DIRECTORIES;

