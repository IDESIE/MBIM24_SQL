------------------------------------------------------------------------------------------------
-- SELECT con subcolsultas y JOINS
------------------------------------------------------------------------------------------------
/*1
Listar de la tabla facilities el id y nombre, 
además de la tabla floors el id, nombre y facilityid
*/
select
    facilities.id,
    facilities.name,
    floors.id,
    floors.name,
    floors.facilityid
from facilities
    join floors on floors.facilityid=facilities.id;
/*2
Lista de id de espacios que no están en la tabla de componentes (spaceid)
pero sí están en la tabla de espacios.LEFT JOIN SALEN TODOS LOS ESPACIOS INCLSO LOS QU ENO SE RELACIONAN CON COMPONENTES. LO OREDAN PARA VER TODOS LOS NULOS AL INCIO
*/ 
select
    spaces.id
from spaces
    left join components on components.spaceid=spaces.id
where
    components.spaceid is null
order by 1 desc

/*3
Lista de id de tipos de componentes que no están en la tabla de componentes (typeid)
pero sí están en la tabla de component_types
*/

select
    component_types.id
from component_types
    left join components on components.typeid= component_types.id
where
    components.typeid is null
and component_types.id is not null;




/*4
Mostrar de la tabla floors los campos: name, id;
y de la tabla spaces los campos: floorid, id, name
de los espacios 109, 100, 111
*/


select
    floors.name,
    floors.id,
    spaces.floorid,
    spaces.id,
    spaces.name
from floors
    join spaces on spaces.floorid=floors.id
where
    spaces.id in (109,100,111);


/*5
Mostrar de component_types los campos: material, id;
y de la tabla components los campos: typeid, id, assetidentifier
de los componentes con id 10000, 20000, 300000
*/

select
    component_types.material,
    component_types.id,
    components.typeid,
    components.id,
    components.assetidentifier
from component_types
    join components on components.typeid= component_types.id
where
    components.id in (10000,20000,30000);

/*6
¿Cuál es el nombre de los espacios que tienen cinco componentes?
*/

select
    spaces.name,
    count(components.id)
from spaces
    left join components on components.spaceid=spaces.id
group by spaces.name
having count(components.id)=5;

/*7
¿Cuál es el id y assetidentifier de los componentes
que están en el espacio llamado CAJERO?
*/select
    c.id,
    c.assetidentifier
from
    components c
    inner join spaces s on c.spaceid = s.id
where
    s.name = 'CAJERO';

select
    components.id,
    components.assetidentifier,
    components.spaceid, 
    spaces.name
   
from components
    join spaces on components.spaceid=spaces.id
where upper(spaces.name) like 'CAJERO'

order by 1 asc;

/*8
¿Cuántos componentes
hay en el espacio llamado CAJERO?
*/select
    count(*) as total_componentes
from
    components c
    inner join spaces s on c.spaceid = s.id
where
    s.name = 'CAJERO';

select
    count(components.id)
   
from components
    join spaces on components.spaceid=spaces.id
where spaces.name like 'CAJERO';
/*9
Mostrar de la tabla spaces: name, id;
y de la tabla components: spaceid, id, assetidentifier
de los componentes con id 10000, 20000, 30000
aunque no tengan datos de espacio.
*/

select
    spaces.name,
    spaces.id,
    components.spaceid, 
    components.id,
    components.assetidentifier
   
from spaces
    right join components on components.spaceid=spaces.id
where components.id=10000 or components.id=20000 or components.id=30000;

/*
10
Listar el nombre de los espacios y su área del facility 1
*/

select
    spaces.name,
    spaces.netarea
   
from spaces
    join floors on spaces.floorid=floors.id
    join facilities on floors.facilityid= facilities.id
where facilities.id=1;

/*11
¿Cuál es el número de componentes por facility?
Mostrar nombre del facility y el número de componentes.
*/

select
    facilities.name,
    count(components.id)
    
from components
   right join facilities on components.facilityid=facilities.id
group by facilities.name;
/*12
¿Cuál es la suma de áreas de los espacios por cada facility?
Mostrar nombre del facility y la suma de las áreas 
*/

select
    facilities.name,
    sum(spaces.netarea)
   
from spaces
    join floors on spaces.floorid=floors.id
    join facilities on floors.facilityid= facilities.id
group by facilities.name;

/*13
¿Cuántas sillas hay de cada tipo?
Mostrar el nombre del facility, el nombre del tipo
y el número de componentes de cada tipo
ordernado por facility.
*/


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


select
    facilities.name,
    component_types.name,
    count(components.id)
    
from component_types
   left join facilities on component_types.facilityid=facilities.id
   left join components on components.typeid=component_types.id
where lower(component_types.name) like '%silla%'
group by facilities.name, component_types.name

order by 1 asc;
/*
14
Listar nombre, código de asset, número de serie, el año de instalación, nombre del espacio,
de todos los componentes
del facility 1
que estén en un aula y no sean tuberias, muros, techos, suelos.
*/
select
    components.name,
    components.assetidentifier,
    components.serialnumber,
    components.INSTALLATEDON,
    spaces.name
    
from components
   left join spaces on components.spaceid=spaces.id
where components.facilityid=1 and
    lower(spaces.name) like '%aula%' and
    lower(components.name) not like '%tuberias%'and
    lower(components.name) not like '%muros%' and
    lower(components.name) not like '%techos%' and
    lower(components.name) not like '%suelos%';

/*
15
Nombre, área bruta y volumen de los espacios con mayor área que la media de áreas del facility 1.
*/

select
    spaces.name,
    spaces.grossarea,
    spaces.volume
    
from spaces
   
where spaces.grossarea> (
    SELECT AVG(spaces.grossarea) 
    FROM spaces
    JOIN floors ON spaces.floorid = floors.id
    WHERE floors.facilityid = 1
);


/*
16
Nombre y fecha de instalación (yyyy-mm-dd) de los componentes del espacio con mayor área del facility 1
*/
select
    components.name,
    to_char(components.INSTALLATEDON, 'yyyy-mm-dd')
    
from components
JOIN spaces ON components.spaceid = spaces.id
   
where spaces.grossarea= (
    SELECT MAX(spaces.grossarea) 
    FROM spaces
    JOIN floors ON spaces.floorid = floors.id
    WHERE floors.facilityid = 1
);


/*
17
Nombre y código de activo  de los componentes cuyo tipo de componente contenga la palabra 'mesa'
del facility 1
*/

select
    components.name,
    components.ASSETIDENTIFIER
    
from components
JOIN component_types on components.typeid=component_types.id
   
where component_types.name like '%mesa%' and
	component_types.facilityid=1;


/*
18
Nombre del componente, espacio y planta de los componentes
de los espacios que sean Aula del facility 1
*/


/*
19
Número de componentes y número de espacios por planta (nombre) del facility 1. 
Todas las plantas.
*/


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


/*
26
Nombre del espacio, y número de grifos del espacio con más grifos del facility 1.
*/


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
select
    rownum,
    fila,
    spacename,
    spacearea
from(select
        rownum fila,
        spaces.name spacename,
        spaces.netarea spacearea
    from spaces
        join floors on spaces.floorid=floors.id
        join facilities on facilities.id= floors.facilityid
    where facilities.id=1
    order by 3 desc) tabla
where rownum < 4;
------------------------------------------------------------------------------------------------
