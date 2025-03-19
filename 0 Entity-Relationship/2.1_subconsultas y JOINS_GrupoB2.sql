 ------------------------------------------------------------------------------------------------  
-- SELECT CON SUBCONSULTAS Y JOINS
 ------------------------------------------------------------------------------------------------

/*1
listar de la tabla facilities el id y nombre, 
además de la tabla floors el id, nombre y facilityid
*/
select f.id as "facility id", f.name as "facility name", fl.id as "floor id", fl.name as "floor name", fl.facilityid
from facilities f
join floors fl on f.id = fl.facilityid;

/*2
lista de id de espacios que no están en la tabla de componentes (spaceid)
pero sí están en la tabla de espacios.
*/
select s.id as "space id"
from spaces s
left join components c on s.id = c.spaceid
where c.spaceid is null;

/*3
lista de id de tipos de componentes que no están en la tabla de componentes (typeid)
pero sí están en la tabla de component_types.
*/


/*4
mostrar de la tabla floors los campos: name, id;
y de la tabla spaces los campos: floorid, id, name
de los espacios 109, 100, 111.
*/
select fl.name as "floor name", fl.id as "floor id", s.floorid, s.id as "space id", s.name as "space name"
from floors fl
join spaces s on fl.id = s.floorid
where s.id in (109, 100, 111);

/*5
mostrar de component_types los campos: material, id;
y de la tabla components los campos: typeid, id, assetidentifier
de los componentes con id 10000, 20000, 300000.
*/
select ct.material, ct.id as "component type id", c.typeid, c.id as "component id", c.assetidentifier
from component_types ct
join components c on ct.id = c.typeid
where c.id in (10000, 20000, 300000);

/*6
¿cuál es el nombre de los espacios que tienen cinco componentes?
*/
select s.name as "space name"
from spaces s
join components c on s.id = c.spaceid
group by s.name
having count(c.id) = 5;

/*7
¿cuál es el id y assetidentifier de los componentes
que están en el espacio llamado cajero?
*/
select c.id as "component id", c.assetidentifier
from components c
join spaces s on c.spaceid = s.id
where lower(s.name) = 'cajero';

/*8
¿cuántos componentes hay en el espacio llamado cajero?
*/
select count(c.id) as "component count"
from components c
join spaces s on c.spaceid = s.id
where lower(s.name) = 'cajero';

/*9
mostrar de la tabla spaces: name, id;
y de la tabla components: spaceid, id, assetidentifier
de los componentes con id 10000, 20000, 30000
aunque no tengan datos de espacio.
*/
select s.name as "space name", s.id as "space id", c.spaceid, c.id as "component id", c.assetidentifier
from spaces s
right join components c on s.id = c.spaceid
where c.id in (10000, 20000, 30000);

/*10
listar el nombre de los espacios y su área del facility 1.
*/
select s.name as "space name", s.grossarea as "area"
from spaces s
join floors fl on s.floorid = fl.id
where fl.facilityid = 1;

/*11
¿cuál es el número de componentes por facility?
mostrar nombre del facility y el número de componentes.
*/
select f.name as "facility name", count(c.id) as "component count"
from facilities f
join floors fl on f.id = fl.facilityid
join spaces s on fl.id = s.floorid
join components c on s.id = c.spaceid
group by f.name;

/*12
¿cuál es la suma de áreas de los espacios por cada facility?
mostrar nombre del facility y la suma de las áreas.
*/
select f.name as "facility name", sum(s.grossarea) as "total area"
from facilities f
join floors fl on f.id = fl.facilityid
join spaces s on fl.id = s.floorid
group by f.name;

/*13
¿cuántas sillas hay de cada tipo?
mostrar el nombre del facility, el nombre del tipo
y el número de componentes de cada tipo
ordenado por facility.
*/
select f.name as "facility name", ct.name as "component type", count(c.id) as "component count"
from facilities f
join floors fl on f.id = fl.facilityid
join spaces s on fl.id = s.floorid
join components c on s.id = c.spaceid
join component_types ct on c.typeid = ct.id
where lower(ct.name) like '%silla%'
group by f.name, ct.name
order by f.name;

/*14
listar nombre, código de asset, número de serie, el año de instalación, nombre del espacio,
de todos los componentes del facility 1 que estén en un aula y no sean tuberías, muros, techos, suelos.
*/
select c.name as "component name", c.assetidentifier, c.serialnumber, extract(year from c.installatedon) as "year of installation", s.name as "space name"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
where fl.facilityid = 1
and lower(s.name) like '%aula%'
and lower(c.name) not in ('tuberia', 'muro', 'techo', 'suelo');

/*15
nombre, área bruta y volumen de los espacios con mayor área que la media de áreas del facility 1.
*/



/*16
nombre y fecha de instalación (yyyy-mm-dd) de los componentes del espacio con mayor área del facility 1
*/
select c.name as "component name", to_char(c.installatedon, 'yyyy-mm-dd') as "installation date"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
where fl.facilityid = 1
and s.grossarea = (
    select max(grossarea)
    from spaces
    where floorid = s.floorid
)
order by c.installatedon;

/*17
nombre y código de activo de los componentes cuyo tipo de componente contenga la palabra 'mesa'
del facility 1
*/
select c.name as "component name", c.assetidentifier
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
join component_types ct on c.typeid = ct.id
where fl.facilityid = 1
and lower(ct.name) like '%mesa%';

/*18
nombre del componente, espacio y planta de los componentes
de los espacios que sean aula del facility 1
*/
select c.name as "component name", s.name as "space name", fl.name as "floor name"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
where fl.facilityid = 1
and lower(s.name) like '%aula%';

/*19
número de componentes y número de espacios por planta (nombre) del facility 1. 
todas las plantas.
*/
select fl.name as "floor name", count(c.id) as "component count", count(distinct s.id) as "space count"
from floors fl
join spaces s on fl.id = s.floorid
join components c on s.id = c.spaceid
where fl.facilityid = 1
group by fl.name;

/*20
número de componentes por tipo de componente en cada espacio
de los componentes que sean mesas del facility 1
ordenados de forma ascendente por el espacio y descendente por el número de componentes.
ejemplo:
componentes    tipo   espacio
--------------------------------
12  mesa-cristal-redonda    aula 2
23  mesa-4x-reclinable      aula 3
1   mesa-profesor           aula 3
21  mesa-cristal-redonda    aula 12
*/
select count(c.id) as "component count", ct.name as "component type", s.name as "space name"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
join component_types ct on c.typeid = ct.id
where fl.facilityid = 1
and lower(ct.name) like '%mesa%'
group by s.name, ct.name
order by s.name asc, count(c.id) desc;

/*21
mostrar el nombre de las aulas y una etiqueta «sillas» que indique
'bajo' si el número de sillas es menor a 6
'alto' si el número de sillas es mayor a 15
'medio' si está entre 6 y 15 inclusive
del facility 1
ordenado ascendentemente por el espacio
ejemplo:
espacio sillas
--------------
aula 1  bajo
aula 2  bajo
aula 3  medio
*/
select s.name ,
       case
           when count(c.id) < 6 then 'bajo'
           when count(c.id) > 15 then 'alto'
           else 'medio'
       end as "sillas"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
join component_types ct on c.typeid = ct.id
where fl.facilityid = 1
and lower(ct.name) like '%silla%'
group by s.name
order by s.name asc;

/*22
tomando en cuenta los cuatro primeros caracteres del nombre de los espacios
del facility 1
listar los que se repiten e indicar el número.
en orden descendente por el número de ocurrencias.
ejemplo:
espacio ocurrencias
aula    18
aseo    4
hall    2
*/
select substring(s.name, 1, 4) as "space prefix", count(*) as "occurrences"
from spaces s
join floors fl on s.floorid = fl.id
where fl.facilityid = 1
group by substring(s.name, 1, 4)
having count(*) > 1
order by count(*) desc;

/*23
nombre y área del espacio que mayor área bruta tiene del facility 1.
*/
select s.name , s.grossarea
from spaces s
join floors fl on s.floorid = fl.id
where fl.facilityid = 1
and s.grossarea = (
    select max(grossarea)
    from spaces
    where floorid = s.floorid
);

/*24
número de componentes instalados entre el 1 de mayo de 2010 y 31 de agosto de 2010
y que sean grifos, lavabos del facility 1
*/
select count(c.id) as "component count"
    from components c
            join spaces s on c.spaceid = s.id
            join floors fl on s.floorid = fl.id
            join component_types ct on c.typeid = ct.id
            where fl.facilityid = 1
            and lower(ct.name) in ('grifo', 'lavabo')
            and c.installatedon between to_date('2010-05-01', 'yyyy-mm-dd') 
            and to_date('2010-08-31', 'yyyy-mm-dd');

/*25
un listado en el que se indique en líneas separadas
una etiqueta que describa el valor, y el valor:
el número de componentes en aula 03 del facility 1, 
el número de sillas en aula 03 del facility 1
el número de mesas o escritorios en aula 03 del facility 1
ejemplo:
componentes 70
sillas 16
mesas 3
*/
select 'componentes' as "label", count(c.id) as "count"
from components c
join spaces s on c.spaceid = s.id
where lower(s.name) = 'aula 03'
and s.floorid in (select id from floors where facilityid = 1)
union
select 'sillas' as "label", count(c.id) as "count"
from components c
join spaces s on c.spaceid = s.id
join component_types ct on c.typeid = ct.id
where lower(s.name) = 'aula 03'
and lower(ct.name) like '%silla%'
and s.floorid in (select id from floors where facilityid = 1)
union
select 'mesas' as "label", count(c.id) as "count"
from components c
join spaces s on c.spaceid = s.id
join component_types ct on c.typeid = ct.id
where lower(s.name) = 'aula 03'
and lower(ct.name) like '%mesa%'
and s.floorid in (select id from floors where facilityid = 1);

/*26
nombre del espacio, y número de grifos del espacio con más grifos del facility 1.
*/
select s.name as "space name", count(c.id) as "grifo count"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
join component_types ct on c.typeid = ct.id
where fl.facilityid = 1
and lower(ct.name) = 'grifo'
group by s.name
order by count(c.id) desc
limit 1;

/*27
¿cuál es el mes en el que más componentes se instalaron del facility 1.
*/
select to_char(c.installatedon, 'yyyy-mm') as "month", count(c.id) as "component count"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
where fl.facilityid = 1
group by to_char(c.installatedon, 'yyyy-mm')
order by count(c.id) desc
limit 1;

/*28
nombre del día en el que más componentes se instalaron del facility 1.
ejemplo: jueves
*/
select to_char(c.installatedon, 'day') as "day of week", count(c.id) as "component count"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
where fl.facilityid = 1
group by to_char(c.installatedon, 'day')
order by count(c.id) desc
limit 1;

/*29
listar los nombres de componentes que están fuera de garantía del facility 1.
*/
select c.name as "component name"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
where fl.facilityid = 1
and c.warrantyend < current_date;

/*30
listar el nombre de los tres espacios con mayor área del facility 1
*/
select s.name as "space name", s.grossarea
from spaces s
join floors fl on s.floorid = fl.id
where fl.facilityid = 1
order by s.grossarea desc
limit 3;

-----------------------------------------------------------------------------------------------