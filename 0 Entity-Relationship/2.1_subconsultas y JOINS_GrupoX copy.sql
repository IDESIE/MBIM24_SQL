------------------------------------------------------------------------------------------------
-- SELECT con subcolsultas y JOINS
------------------------------------------------------------------------------------------------
/*1
Listar de la tabla facilities el id y nombre, 
además de la tabla floors el id, nombre y facilityid
*/
select f.id as "facility id", f.name as "facility name", fl.id as "floor id", fl.name as "floor name", fl.facilityid
from facilities f
join floors fl on f.id = fl.facilityid;
/*2
Lista de id de espacios que no están en la tabla de componentes (spaceid)
pero sí están en la tabla de espacios.
*/ 
select s.id as "space id"
from spaces s
left join components c on s.id = c.spaceid
where c.spaceid is null;
/*3
Lista de id de tipos de componentes que no están en la tabla de componentes (typeid)
pero sí están en la tabla de component_types
*/
select ct.id as "type id"
from component_type
left join components t on ct.id = c.typeid
where c.typeid is null;
/*4
Mostrar de la tabla floors los campos: name, id;
y de la tabla spaces los campos: floorid, id, name
de los espacios 109, 100, 111
*/
select fl.name as "floor name", fl.id as "floor id", s.floorid, s.id as "space id", s.name as "space name"
from floors fl
join spaces s on fl.id = s.floorid
where s.id in (109, 100, 111);
/*5
Mostrar de component_types los campos: material, id;
y de la tabla components los campos: typeid, id, assetidentifier
de los componentes con id 10000, 20000, 300000
*/
select ct.material, ct.id as "component type id", c.typeid, c.id as "component id", c.assetidentifier
from component_types ct
join components c on ct.id = c.typeid
where c.id in (10000, 20000, 300000);
/*6
¿Cuál es el nombre de los espacios que tienen cinco componentes?
*/
select s.name as "space name"
from spaces s
join components c on s.id = c.spaceid
group by s.name
having count(c.id) = 5;
/*7
¿Cuál es el id y assetidentifier de los componentes
que están en el espacio llamado CAJERO?
*/
select c.id as "component id", c.assetidentifier
from components c
join spaces s on c.spaceid = s.id
where lower(s.name) = 'cajero';
/*8
¿Cuántos componentes
hay en el espacio llamado CAJERO?
*/
select count(c.id) as "component count"
from components c
join spaces s on c.spaceid = s.id
where lower(s.name) = 'cajero';
/*9
Mostrar de la tabla spaces: name, id;
y de la tabla components: spaceid, id, assetidentifier
de los componentes con id 10000, 20000, 30000
aunque no tengan datos de espacio.
*/
select s.name as "space name", s.id as "space id", c.spaceid, c.id as "component id", c.assetidentifier
from spaces s
right join components c on s.id = c.spaceid
where c.id in (10000, 20000, 30000);
/*
10
Listar el nombre de los espacios y su área del facility 1
*/
select s.name as "space name", s.grossarea as "area"
from spaces s
join floors fl on s.floorid = fl.id
where fl.facilityid = 1;
/*11
¿Cuál es el número de componentes por facility?
Mostrar nombre del facility y el número de componentes.
*/
select f.name as "facility name", count(c.id) as "component count"
from facilities f
join floors fl on f.id = fl.facilityid
join spaces s on fl.id = s.floorid
join components c on s.id = c.spaceid
group by f.name;

/*12
¿Cuál es la suma de áreas de los espacios por cada facility?
Mostrar nombre del facility y la suma de las áreas 
*/
select f.name as "facility name", sum(s.grossarea) as "total area"
from facilities f
join floors fl on f.id = fl.facilityid
join spaces s on fl.id = s.floorid
group by f.name;

/*13
¿Cuántas sillas hay de cada tipo?
Mostrar el nombre del facility, el nombre del tipo
y el número de componentes de cada tipo
ordernado por facility.
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

--Ejemplo
--Alegra	Silla-Apilable_Silla-Apilable	319
--Alegra	Silla-Brazo escritorio_Silla-Brazo escritorio	24
--Alegra	Silla (3)_Silla (3)	24
--Alegra	Silla-Corbu_Silla-Corbu	20
--Alegra	Silla-Oficina (brazos)_Silla-Oficina (brazos)	17
--COSTCO	Silla-Apilable_Silla-Apilable	169
--COSTCO	Silla_Silla	40
--COSTCO	Silla-Corbu_Silla-Corbu	14
--COSTCO	Silla-Oficina (brazos)_Silla-Oficina (brazos)	188

/*
14
Listar nombre, código de asset, número de serie, el año de instalación, nombre del espacio,
de todos los componentes
del facility 1
que estén en un aula y no sean tuberias, muros, techos, suelos.
*/
select c.name as "component name", c.assetidentifier, c.serialnumber, extract(year from c.installatedon) as "year of installation", s.name as "space name"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
where fl.facilityid = 1
and lower(s.name) like '%aula%'
and lower(c.name) not in ('tuberia', 'muro', 'techo', 'suelo');

/*
15
Nombre, área bruta y volumen de los espacios con mayor área que la media de áreas del facility 1.
*/


/*
16
Nombre y fecha de instalación (yyyy-mm-dd) de los componentes del espacio con mayor área del facility 1
*/
select c.name as "nombre del componente", to_char(c.installatedon, 'yyyy-mm-dd') as "fecha de instalación"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
where fl.facilityid = 1
and s.grossarea = (
    select max(grossarea)
    from spaces
    where floorid = s.floorid

/*
17
Nombre y código de activo  de los componentes cuyo tipo de componente contenga la palabra 'mesa'
del facility 1
*/
select c.name as "nombre del componente", c.assetidentifier as "código de activo"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
join component_types ct on c.typeid = ct.id
where fl.facilityid = 1
and lower(ct.name) like '%mesa%';

/*
18
Nombre del componente, espacio y planta de los componentes
de los espacios que sean Aula del facility 1
*/
select c.name as "nombre del componente", s.name as "nombre del espacio", fl.name as "nombre de la planta"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
where fl.facilityid = 1
and lower(s.name) like '%aula%';

/*
19
Número de componentes y número de espacios por planta (nombre) del facility 1. 
Todas las plantas.
*/
select fl.name as "nombre de la planta", count(c.id) as "número de componentes", count(distinct s.id) as "número de espacios"
from floors fl
join spaces s on fl.id = s.floorid
join components c on s.id = c.spaceid
where fl.facilityid = 1
group by fl.name;

/*
20
Número de componentes por tipo de componente en cada espacio
de los componentes que sean mesas del facility 1
ordenados de forma ascendente por el espacio y descentente por el número de componentes.
Ejmplo:
Componentes    Tipo   Espacio
--------------------------------
12  Mesa-cristal-redonda    Aula 2
23  Mesa-4x-reclinable      Aula 3
1   Mesa-profesor           Aula 3
21  Mesa-cristal-redonda    Aula 12
*/
select count(c.id) as "número de componentes", ct.name as "tipo de componente", s.name as "nombre del espacio"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
join component_types ct on c.typeid = ct.id
where fl.facilityid = 1
and lower(ct.name) like '%mesa%'
group by s.name, ct.name
order by s.name asc, count(c.id) desc;

/*
21
Mostrar el nombre de las Aulas y una etiqueda «Sillas» que indique
'BAJO' si el número de sillas es menor a 6
'ALTO' si el número de sillas es mayor a 15
'MEDIO' si está entre 6 y 15 inclusive
del facility 1
ordenado ascendentemente por el espacio
Ejemplo:
Espacio Sillas
--------------
Aula 1  BAJO
Aula 2  BAJO
Aula 3  MEDIO
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

/*
22
Tomando en cuenta los cuatro primeros caracteres del nombre de los espacios
del facility 1
listar los que se repiten e indicar el número.
En orden descendente por el número de ocurrencias.
Ejemplo:
Espacio Ocurrencias
Aula    18
Aseo    4
Hall    2
*/


/*
23
Nombre y área del espacio que mayor área bruta tiene del facility 1.
*/


/*
24
Número de componentes instalados entre el 1 de mayo de 2010 y 31 de agosto de 2010
y que sean grifos, lavabos del facility 1
*/
select count(c.id) as "número de componentes"
    from components c
            join spaces s on c.spaceid = s.id
            join floors fl on s.floorid = fl.id
            join component_types ct on c.typeid = ct.id
            where fl.facilityid = 1
            and lower(ct.name) in ('grifo', 'lavabo')
            and c.installatedon between to_date('2010-05-01', 'yyyy-mm-dd') 
            and to_date('2010-08-31', 'yyyy-mm-dd');

/*
25
Un listado en el que se indique en líneas separadas
una etiqueta que describa el valor, y el valor:
el número de componentes en Aula 03 del facility 1, 
el número de sillas en Aula 03 del facility 1
el número de mesas o escritorios en Aula 03 del facility 1
Ejemplo:
Componentes 70
Sillas 16
Mesas 3
*/
select 'componentes' as "etiqueta", count(c.id) as "número"
from components c
join spaces s on c.spaceid = s.id
where lower(s.name) = 'aula 03'
and s.floorid in (select id from floors where facilityid = 1)
union
select 'sillas' as "etiqueta", count(c.id) as "número"
from components c
join spaces s on c.spaceid = s.id
join component_types ct on c.typeid = ct.id
where lower(s.name) = 'aula 03'
and lower(ct.name) like '%silla%'
and s.floorid in (select id from floors where facilityid = 1)
union
select 'mesas' as "etiqueta", count(c.id) as "número"
from components c
join spaces s on c.spaceid = s.id
join component_types ct on c.typeid = ct.id
where lower(s.name) = 'aula 03'
and lower(ct.name) like '%mesa%'
and s.floorid in (select id from floors where facilityid = 1);

/*
26
Nombre del espacio, y número de grifos del espacio con más grifos del facility 1.
*/
select s.name as "nombre del espacio", count(c.id) as "número de grifos"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
join component_types ct on c.typeid = ct.id
where fl.facilityid = 1
and lower(ct.name) = 'grifo'
group by s.name
order by count(c.id) desc
limit 1;

/*
27
Cuál es el mes en el que más componentes se instalaron del facility 1.
*/


/* 28
Nombre del día en el que más componentes se instalaron del facility 1.
Ejemplo: Jueves
*/

/*29
Listar los nombres de componentes que están fuera de garantía del facility 1.
*/

/*
30
Listar el nombre de los tres espacios con mayor área del facility 1
*/

------------------------------------------------------------------------------------------------
