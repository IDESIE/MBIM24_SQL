------------------------------------------------------------------------------------------------
-- SELECT CON FUNCIONES
------------------------------------------------------------------------------------------------
/* 1
Mostrar la fecha actual de la siguiente forma:
Fecha actual
------------------------------
Sábado, 11 de febrero de 2027. 16:06:06

El día en palabras con la primera letra en mayúsculas, seguida de una coma, el día en números,
la palabra "de", el mes en minúscula en palabras, la palabra "de", el año en cuatro dígitos
finalizando con un punto. Luego la hora en formato 24h con minutos y segundos.
Y de etiqueta del campo "Fecha actual".
*/
select
    to_char(current_timestamp, 'FMDay, DD "de" FMMonth "de" YYYY. HH24:MI:SS');
/* 2
Día en palabras de cuando se instalaron los componentes
del facility 1
*/
select
    to_char(components.installation_date, 'Day')
from
    components
    join spaces on components.space_id = spaces.id
    join floors on spaces.floor_id = floors.id
    join facilities on floors.facility_id = facilities.id
where
    facilities.id = 1;
/* 3
De los espacios, obtener la suma de áreas, cuál es el mínimo, el máximo y la media de áreas
del floorid 1. Redondeado a dos dígitos.
*/
select 
count (netarea),
sum (netarea),
min (netarea),
max (netarea),
round(avg(netarea),5)
from spaces
where floorid =1;
/* 4
¿Cuántos componentes tienen espacio? ¿Cuántos componentes hay?
En el facility 1. Ej.
ConEspacio  Componentes
----------------------------
3500  4000
*/
select 
count (id),
count (*),
count (spaceid),
count (distinct spaceid)
from components
where facilityid =1;
/* 5
Mostrar tres medias que llamaremos:
-Media a la media del área bruta
-MediaBaja la media entre el área media y el área mínima
-MediaAlta la media entre el área media y el área máxima
de los espacios del floorid 1
Solo la parte entera, sin decimales ni redondeo.
*/
select
    trunc(avg(spaces.gross_area)),
    trunc((avg(spaces.gross_area) + min(spaces.gross_area)) / 2),
    trunc((avg(spaces.gross_area) + max(spaces.gross_area)) / 2)
from
    spaces
where
    spaces.floor_id = 1;
/* 6
Cuántos componentes hay, cuántos tienen fecha inicio de garantia, cuántos tienen espacio, y en cuántos espacios hay componentes
en el facility 1.
*/
select
    count(components.id),
    count(components.warranty_start_date),
    count(components.space_id),
    count(distinct components.space_id)
from
    components
    join spaces on components.space_id = spaces.id
    join floors on spaces.floor_id = floors.id
    join facilities on floors.facility_id = facilities.id
where
    facilities.id = 1;
/* 7
Mostrar cuántos espacios tienen el texto 'Aula' en el nombre
del facility 1.
*/
select 
name
from spaces
where floorid =1
or floorid =2
or floorid =3
or floorid =4;
////////
select 
name
from spaces
where floorid in (1,2,3,4);

select id
from floors where facilityid = 1;
////////
select 
count (name)
from spaces
where floorid in (select id
from floors where facilityid =1)
and lower(name) like '%aula%';
/* 8
Mostrar el porcentaje de componentes que tienen fecha de inicio de garantía
del facility 1.
*/
select 
    (count(case when warrantystarton is not null then 1 end) * 100.0 / count(*)) as porcentaje_con_garantia
from 
    components
where 
    facilityid = 1;
/* 9
Listar las cuatro primeras letras del nombre de los espacios sin repetir
de la planta 1. 
En orden ascendente.
Ejemplo:
Aula
Area
Aseo
Pasi
Pati
Serv
*/
select
    distinct substr(spaces.name, 1, 4)
from
    spaces
where
    spaces.floor_id = 1
order by
    substr(spaces.name, 1, 4);
/* 10
Número de componentes por fecha de instalación del facility 1
ordenados descendentemente por la fecha de instalación
Ejemplo:
Fecha   Componentes
-------------------
2021-03-23 34
2021-03-03 232
*/
select
    components.installation_date,
    count(components.id)
from
    components
    join spaces on components.space_id = spaces.id
    join floors on spaces.floor_id = floors.id
    join facilities on floors.facility_id = facilities.id
where
    facilities.id = 1
group by
    components.installation_date
order by
    components.installation_date desc;
/* 11
Un listado por año del número de componentes instalados del facility 1
ordenados descendentemente por año.
Ejemplo
Año Componentes
---------------
2021 344
2020 2938
*/
select
    extract(year from components.installation_date),
    count(components.id)
from
    components
    join spaces on components.space_id = spaces.id
    join floors on spaces.floor_id = floors.id
    join facilities on floors.facility_id = facilities.id
where
    facilities.id = 1
group by
    extract(year from components.installation_date)
order by
    extract(year from components.installation_date) desc;
/* 12
Nombre del día de instalación y número de componentes del facility 1.
ordenado de lunes a domingo
Ejemplo:
Día         Componentes
-----------------------
Lunes    	503
Martes   	471
Miércoles	478
Jueves   	478
Viernes  	468
Sábado   	404
Domingo  	431
*/
select 
    to_char(installatedon, 'D') as numero_dia, -- Número del día (1=domingo, 2=lunes, ..., 7=sábado)
    to_char(installatedon, 'Day') as dia_semana, -- Nombre del día (con espacios)
    count(id) as total_componentes
from 
    components
where 
    facilityid = 1
group by 
    to_char(installatedon, 'D'),
    to_char(installatedon, 'Day')
order by 
    to_char(installatedon, 'D');
/*13
Mostrar en base a los cuatro primeros caracteres del nombre cuántos espacios hay
del floorid 1 ordenados ascendentemente por el nombre.
Ejemplo.
Aula 23
Aseo 12
Pasi 4
*/
select
    substr(spaces.name, 1, 4),
    count(spaces.id)
from
    spaces
where
    spaces.floor_id = 1
group by
    substr(spaces.name, 1, 4)
order by
    substr(spaces.name, 1, 4);
/*14
Cuántos componentes de instalaron un Jueves
en el facilityid 1
*/
select 
    count(*) as componentes_instalados_jueves
from 
    components
where 
    facilityid = 1
    and trim(to_char(installatedon, 'Day')) = 'Jueves'
/*15
Listar el id de planta concatenado con un guión
seguido del id de espacio concatenado con un guión
y seguido del nombre del espacio.
el id del espacio debe tener una longitud de 3 caracteres
Ej. 3-004-Nombre
*/
 select
    floors.id || '-' || lpad(spaces.id, 3, '0') || '-' || spaces.name
from
    spaces
    join floors on spaces.floor_id = floors.id;
------------------------------------------------------------------------------------------------
