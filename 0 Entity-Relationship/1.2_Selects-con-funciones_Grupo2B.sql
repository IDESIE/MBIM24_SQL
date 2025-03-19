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

/* 2
Día en palabras de cuando se instalaron los componentes del facility 1
*/
select to_char(installatedon, 'FMDay') as "día de instalación"
from components
join spaces on components.spaceid = spaces.id
join floors on spaces.floorid = floors.id
where floors.facilityid = 1;

/* 3
De los espacios, obtener la suma de áreas, cuál es el mínimo, el máximo y la media de áreas
del floorid 1. Redondeado a dos dígitos.
*/
select 
    round(sum(grossarea), 2) as "suma areas",
    round(min(grossarea), 2) as "área minima",
    round(max(grossarea), 2) as "área maxima",
    round(avg(grossarea), 2) as "área media"
from spaces
where floorid = 1;

/* 4
¿Cuántos componentes tienen espacio? ¿Cuántos componentes hay?
En el facility 1.
*/
select 
    count(case when spaceid is not null then 1 end) as "ConEspacio", 
    count(id) as "Componentes"
from components
join spaces on components.spaceid = spaces.id
join floors on spaces.floorid = floors.id
where floors.facilityid = 1;

/* 5
Mostrar tres medias que llamaremos:
-Media a la media del área bruta
-MediaBaja la media entre el área media y el área mínima
-MediaAlta la media entre el área media y el área máxima
de los espacios del floorid 1
Solo la parte entera, sin decimales ni redondeo.
*/
with stats as (
    select 
        avg(grossarea) as media,
        min(grossarea) as minima,
        max(grossarea) as maxima
    from spaces
    where floorid = 1
)
select 
    floor(media) as "media",
    floor((media + minima) / 2) as "mediabaja",
    floor((media + maxima) / 2) as "mediaalta"
from stats;

/* 6
Cuántos componentes hay, cuántos tienen fecha inicio de garantía, cuántos tienen espacio, 
y en cuántos espacios hay componentes en el facility 1.
*/
select 
    count(id) as "componentes_totales",
    count(case when startwarranty is not null then 1 end) as "con_fecha_inicio_garantía",
    count(case when spaceid is not null then 1 end) as "con_espacio",
    count(distinct spaceid) as "espacios_con_componentes"
from components
join spaces on components.spaceid = spaces.id
join floors on spaces.floorid = floors.id
where floors.facilityid = 1;

/* 7
Mostrar cuántos espacios tienen el texto 'Aula' en el nombre del facility 1.
*/
select count(*)
from spaces
where lower(name) like '%aula%'
and floorid in (select id from floors where facilityid = 1);

/* 8
Mostrar el porcentaje de componentes que tienen fecha de inicio de garantía del facility 1.
*/

select 
    round((count(case when startwarranty is not null then 1 end) * 100.0) / count(*), 2) as "porcentaje de componentes con garantía"
from components
where spaceid in (select id from spaces where floorid in (select id from floors where facilityid = 1));

/* 9
Listar las cuatro primeras letras del nombre de los espacios sin repetir
de la planta 1 en orden ascendente.
*/

select distinct substr(name, 1, 4) as "first_4_letters"
from spaces
where floorid = 1
order by "first_4_letters" asc;

/* 10
Número de componentes por fecha de instalación del facility 1
ordenados descendentemente por la fecha de instalación.
*/

select installatedon, count(*)
from components
where spaceid in (select id from spaces where floorid in (select id from floors where facilityid = 1))
group by installatedon
order by installatedon desc;

/* 11
Un listado por año del número de componentes instalados del facility 1
ordenados descendentemente por año.
*/
select extract(year from installatedon) as "year", count(*)
from components
where spaceid in (select id from spaces where floorid in (select id from floors where facilityid = 1))
group by extract(year from installatedon)
order by "year" desc;

/* 12
Nombre del día de instalación y número de componentes del facility 1
ordenado de lunes a domingo.
*/
select to_char(installatedon, 'day') as "installation_day", count(*)
from components
where spaceid in (select id from spaces where floorid in (select id from floors where facilityid = 1))
group by to_char(installatedon, 'day')
order by to_char(installatedon, 'd') asc;

/* 13
Mostrar en base a los cuatro primeros caracteres del nombre cuántos espacios hay
del floorid 1 ordenados ascendentemente por el nombre.
*/

select substr(name, 1, 4) as "first_4_letters", count(*)
from spaces
where floorid = 1
group by substr(name, 1, 4)
order by "first_4_letters" asc;

/* 14
Cuántos componentes se instalaron un Jueves en el facilityid 1.
*/
select count(*)
from components
where to_char(installatedon, 'day') = 'thursday'
and spaceid in (select id from spaces where floorid in (select id from floors where facilityid = 1));

/* 15
Listar el id de planta concatenado con un guión seguido del id de espacio concatenado con un guión
y seguido del nombre del espacio. El id del espacio debe tener una longitud de 3 caracteres.
*/
select floorid || '-' || lpad(id, 3, '0') || '-' || name as "space_details"
from spaces
where floorid in (select id from floors where facilityid = 1);