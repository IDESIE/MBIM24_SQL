------------------------------------------------------------------------------------------------
-- SELECT con subcolsultas y JOINS
------------------------------------------------------------------------------------------------
/*1
Listar de la tabla facilities el id y nombre, 
además de la tabla floors el id, nombre y facilityid
*/
SELECT 
    facilities.id, 
    facilities.name, 
    floors.id, 
    floors.name, 
    floors.facilityId
FROM facilities
JOIN floors ON facilities.id = floors.facilityId;

/*2
Lista de id de espacios que no están en la tabla de componentes (spaceid)
pero sí están en la tabla de espacios.
*/ 
SELECT spaces.id
FROM spaces
LEFT JOIN components ON spaces.id = components.spaceId
WHERE components.spaceId IS NULL;


/*3
Lista de id de tipos de componentes que no están en la tabla de componentes (typeid)
pero sí están en la tabla de component_types
*/
SELECT types.id
FROM types
LEFT JOIN components ON types.id = components.typeId
WHERE components.typeId IS NULL;

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
SELECT 
    floors.id, 
    floors.name, 
    spaces.floorId, 
    spaces.id, 
    spaces.name
FROM floors
JOIN spaces ON floors.id = spaces.floorId
WHERE spaces.id IN (109, 100, 111);

/*6
¿Cuál es el nombre de los espacios que tienen cinco componentes?
*/
SELECT spaces.name
FROM spaces
JOIN components ON spaces.id = components.spaceId
GROUP BY spaces.id, spaces.name
HAVING COUNT(components.id) = 5;


/*7
¿Cuál es el id y assetidentifier de los componentes
que están en el espacio llamado CAJERO?
*/
SELECT components.id, components.serialNumber
FROM components
JOIN spaces ON components.spaceId = spaces.id
WHERE spaces.name = 'CAJERO';


/*8
¿Cuántos componentes
hay en el espacio llamado CAJERO?
*/
SELECT COUNT(components.id)
FROM components
JOIN spaces ON components.spaceId = spaces.id
WHERE spaces.name = 'CAJERO';


/*9
Mostrar de la tabla spaces: name, id;
y de la tabla components: spaceid, id, assetidentifier
de los componentes con id 10000, 20000, 30000
aunque no tengan datos de espacio.
*/
SELECT 
    spaces.id, 
    spaces.name, 
    components.spaceId, 
    components.id, 
    components.serialNumber 
FROM components
LEFT JOIN spaces ON components.spaceId = spaces.id
WHERE components.id IN (10000, 20000, 30000);

/*
10
Listar el nombre de los espacios y su área del facility 1
*/
SELECT spaces.name, spaces.area
FROM spaces
JOIN floors ON spaces.floorId = floors.id
WHERE floors.facilityId = 1;

/*11
¿Cuál es el número de componentes por facility?
Mostrar nombre del facility y el número de componentes.
*/
SELECT 
    facilities.name, 
    COUNT(components.id) 
FROM facilities
LEFT JOIN floors ON facilities.id = floors.facilityId
LEFT JOIN spaces ON floors.id = spaces.floorId
LEFT JOIN components ON spaces.id = components.spaceId
GROUP BY facilities.name;

/*12
¿Cuál es la suma de áreas de los espacios por cada facility?
Mostrar nombre del facility y la suma de las áreas 
*/
SELECT 
    facilities.name, 
    SUM(spaces.area) 
FROM facilities
LEFT JOIN floors ON facilities.id = floors.facilityId
LEFT JOIN spaces ON floors.id = spaces.floorId
GROUP BY facilities.name;

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
from
    facilities
    join floors on facilities.id = floors.facilityid
    join spaces on floors.id = spaces.floorid
    join components on spaces.id = components.spaceid
    join component_types on components.typeid = component_types.id
where
    component_types.name like 'Silla%'
group by
    facilities.name, component_types.name
order by
    facilities.name;

/*
14
Listar nombre, código de asset, número de serie, el año de instalación, nombre del espacio,
de todos los componentes
del facility 1
que estén en un aula y no sean tuberias, muros, techos, suelos.
*/
SELECT 
    components.name,
    components.serialNumber,
    components.serialNumber,
    components.installatedOn,
    spaces.name 
FROM components
JOIN spaces ON components.spaceId = spaces.id
JOIN floors ON spaces.floorId = floors.id
JOIN facilities ON floors.facilityId = facilities.id
WHERE facilities.id = 1
AND spaces.name LIKE '%aula%'  -- Suponiendo que los espacios que son aulas contienen 'aula' en su nombre
AND components.typeId NOT IN (  -- Excluyendo tipos de componentes como tuberías, muros, techos, suelos
    SELECT id FROM types WHERE name IN ('Tubería', 'Muro', 'Techo', 'Suelo')

/*
15
Nombre, área bruta y volumen de los espacios con mayor área que la media de áreas del facility 1.
*/
SELECT 
    spaces.name,
    spaces.area,
    spaces.usableHeight * spaces.area  -- Suponiendo que el volumen es el área * altura usable
FROM spaces
JOIN floors ON spaces.floorId = floors.id
JOIN facilities ON floors.facilityId = facilities.id
WHERE facilities.id = 1
AND spaces.area > (
    SELECT AVG(area) 
    FROM spaces
    JOIN floors ON spaces.floorId = floors.id
    WHERE floors.facilityId = 1
);

/*
16
Nombre y fecha de instalación (yyyy-mm-dd) de los componentes del espacio con mayor área del facility 1
*/
SELECT 
    components.name,
    DATE_FORMAT(components.installatedOn, '%Y-%m-%d') 
FROM components
JOIN spaces ON components.spaceId = spaces.id
JOIN floors ON spaces.floorId = floors.id
JOIN facilities ON floors.facilityId = facilities.id
WHERE facilities.id = 1
AND spaces.id = (
    SELECT id
    FROM spaces
    JOIN floors ON spaces.floorId = floors.id
    WHERE floors.facilityId = 1
    ORDER BY spaces.area DESC
    LIMIT 1
);

/*
17
Nombre y código de activo  de los componentes cuyo tipo de componente contenga la palabra 'mesa'
del facility 1
*/
SELECT 
    components.name,
    components.serialNumber 
FROM components
JOIN spaces ON components.spaceId = spaces.id
JOIN floors ON spaces.floorId = floors.id
JOIN facilities ON floors.facilityId = facilities.id
JOIN types ON components.typeId = types.id
WHERE facilities.id = 1
AND types.name LIKE '%mesa%';

/*
18
Nombre del componente, espacio y planta de los componentes
de los espacios que sean Aula del facility 1
*/
SELECT 
    components.name,
    spaces.name,
    floors.name 
FROM components
JOIN spaces ON components.spaceId = spaces.id
JOIN floors ON spaces.floorId = floors.id
JOIN facilities ON floors.facilityId = facilities.id
WHERE facilities.id = 1
AND spaces.name LIKE '%Aula%';

/*
19
Número de componentes y número de espacios por planta (nombre) del facility 1. 
Todas las plantas.
*/
SELECT 
    floors.name,
    COUNT(DISTINCT spaces.id),
    COUNT(DISTINCT components.id) 
FROM floors
LEFT JOIN spaces ON floors.id = spaces.floorId
LEFT JOIN components ON spaces.id = components.spaceId
WHERE floors.facilityId = 1
GROUP BY floors.name;

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
SELECT 
    COUNT(components.id),
    types.name,
    spaces.name 
FROM components
JOIN spaces ON components.spaceId = spaces.id
JOIN floors ON spaces.floorId = floors.id
JOIN facilities ON floors.facilityId = facilities.id
JOIN types ON components.typeId = types.id
WHERE facilities.id = 1
AND types.name LIKE '%mesa%'  -- Filtrando por tipo de componente que contenga 'mesa'
GROUP BY types.name, spaces.name
ORDER BY spaces.name ASC, COUNT(components.id) DESC;

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
SELECT 
    spaces.name,
    CASE
        WHEN COUNT(components.id) < 6 THEN 'BAJO'
        WHEN COUNT(components.id) > 15 THEN 'ALTO'
        ELSE 'MEDIO'
    END AS sillas
FROM components
JOIN spaces ON components.spaceId = spaces.id
JOIN floors ON spaces.floorId = floors.id
JOIN facilities ON floors.facilityId = facilities.id
JOIN types ON components.typeId = types.id
WHERE facilities.id = 1
AND spaces.name LIKE '%Aula%'  -- Filtrando solo los espacios que contienen 'Aula'
AND types.name LIKE '%Silla%'  -- Filtrando solo los componentes de tipo 'Silla'
GROUP BY spaces.name
ORDER BY spaces.name ASC;

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

from (select
    rownum fila,
    spaces.name spacename,
    spaces.netarea spacearea
        from spaces
        join floors on spaces.floorid = floors.id
        join facilities on facilities.id = floors.facilityid
        where facilities.id = 1
        order by 3 desc) tabla
        
        where rownum < 4;
------------------------------------------------------------------------------------------------
