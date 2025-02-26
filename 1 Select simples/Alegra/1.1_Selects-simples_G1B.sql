------------------------------------------------------------------------------------------------
--SELECTS SIMPLES
------------------------------------------------------------------------------------------------
/* 1
Describir la tabla floors
*/
desc floors;
/* 2
Describir la tabla spaces
*/
desc spaces;
/* 3
Datos de la tabla components
*/
select *
from components;
/* 4
Datos de la tabla component_types
*/
select *
from component_types;
/* 5
Id, nombre de los facilities
*/
select 
    id, 
    name
from facilities;
/* 6
Nombre, elevación e id del facility de las plantas
*/
select 
    name, 
    elevation, 
    facilityid
from floors;
/* 7
Nombre, area bruta, volumen de los espacios
*/
select  
    name, 
    grossarea, 
    volume
from spaces;
/* 8
Nombre, vida útil de los tipos de componentes del facility 1
*/
select 
    name, 
    expectedlife, 
    facilityid
from component_types
where facilityid = 1;
/* 9
Nombre de los espacios de la Planta 1 del facility 1
*/
/*Previamente se consulta cuál es el floorid
listando los */
select 
    id, name
from floors
where 
    facilityid = 1 
    and name like '%+1%';

select name, floorid
from spaces
where floorid = 1;
/* 10
Nombre, número de modelo del tipo de componente con id = 60
*/
select 
    name, 
    modelnumber
from component_types
where id = 60;
/* 11
Nombre y fecha de instalación de los componentes del espacio 60 ordenados descendentemente por la fecha de instalación
*/
select 
    name, 
    installatedon
from components
where spaceid = 60
order by installatedon desc;
/* 12
Listar las distintas fechas de instalación de los componentes del facility 1 ordenados descendentemente.
*/
select distinct installatedon
from components
where facilityid = 1
order by installatedon desc;
/* 13
Listar los distintos GUIDs de los componentes del facility 1 ordenados ascendentemente por fecha de garantía.
*/
SELECT DISTINCT GUID
FROM Componentes
WHERE FacilityID = 1
ORDER BY FechaGarantia ASC;
/* 14
Id, código de activo, GUID, número de serie y nombre de los componentes cuyo spaceid está entre 10 y 27 inclusive
ordenados por id de espacio descendentemente.
*/
SELECT Id, CodigoActivo, GUID, NumeroSerie, Nombre
FROM Componentes
WHERE SpaceID BETWEEN 10 AND 27
ORDER BY SpaceID DESC;
/* 15
Id, código de activo, GUID, número de serie y nombre de los componentes del facility 1 
ordenados por código de activo descendentemente.
*/
SELECT Id, CodigoActivo, GUID, NumeroSerie, Nombre
FROM Componentes
WHERE FacilityID = 1
ORDER BY CodigoActivo DESC;
/* 16
Códigos de activo de los componentes del espacio con id 21
ordenados por código de activo descendentemente.
*/
SELECT CodigoActivo
FROM Componentes
WHERE SpaceID = 21
ORDER BY CodigoActivo DESC;
/* 17
Las distintas fechas de instalación de los componentes 
de los espacios con id 10, 12, 16, 19 
ordenadas descendentemente.
*/
SELECT DISTINCT FechaInstalacion
FROM Componentes
WHERE SpaceID IN (10, 12, 16, 19)
ORDER BY FechaInstalacion DESC;
/* 18
Nombre, volumen, de los espacios
cuyo volumen es mayor a 90 de floorid = 1
ordenados por volumen descendentemente
*/
SELECT Nombre, Volumen
FROM Espacios
WHERE Volumen > 90 AND FloorID = 1
ORDER BY Volumen DESC;
/* 19
Nombre, volumen de los espacios
cuyo volumen es mayor a 6 y menor a 9 de la planta con id = 1
*/
SELECT Nombre, Volumen
FROM Espacios
WHERE Volumen > 6 AND Volumen < 9 AND FloorID = 1;
/* 20
Nombre, código de activo, número de serie de los componentes
que no tengan espacio del facility 1
ordenados descendentemente por código de activo
*/
SELECT Nombre, CodigoActivo, NumeroSerie
FROM Componentes
WHERE SpaceID IS NULL AND FacilityID = 1
ORDER BY CodigoActivo DESC;
/* 21
Nombre, código de activo, número de serie de los componentes
que tengan número de serie del facility 1
*/
SELECT Nombre, CodigoActivo, NumeroSerie
FROM Componentes
WHERE NumeroSerie IS NOT NULL AND FacilityID = 1;
/* 22
Nombre de los espacios que empiezan por la letra A donde floorid = 1
*/
SELECT Nombre
FROM Espacios
WHERE Nombre LIKE 'A%' AND FloorID = 1;
/* 23
Lista de espacios que su segunda letra es una 's' donde floorid = 1
*/
SELECT Nombre
FROM Espacios
WHERE Nombre LIKE '_s%' AND FloorID = 1;
/* 24
Lista de tipos de componente del facility 1 
donde el nombre contiene el texto 'con'
y no tienen vida útil indicada o fecha de garantia 
*/
SELECT DISTINCT TipoComponente
FROM Componentes
WHERE FacilityID = 1
     AND Nombre LIKE '%con%'
     AND (VidaUtil IS NULL OR FechaGarantia IS NULL);
/* 25
Nombres de espacios y volumen
pero como volumen una etiqueta que indique 
'BAJO' si es menor a 10, 'ALTO' si es mayor a 1000
y 'MEDIO' si está entre medias
*/
SELECT Nombre,
       CASE 
           WHEN Volumen < 10 THEN 'BAJO'
           WHEN Volumen > 1000 THEN 'ALTO'
           ELSE 'MEDIO'
       END AS VolumenEtiqueta
FROM Espacios;
/* 26
Nombre, fecha de instalación, fecha de garantia
de los componentes del facility 1
que tienen fecha de garantia
*/
SELECT Nombre, FechaInstalacion, FechaGarantia
FROM Componentes
WHERE FacilityID = 1
  AND FechaGarantia IS NOT NULL;
/* 27
Lista de nombres de espacio que su id no es 4, 9, ni 19
del floorid 1
*/
SELECT Nombre
FROM Espacios
WHERE FloorID = 1
  AND SpaceID NOT IN (4, 9, 19);
/* 28
Lista de espacios que no son Aula del floorid = 1
*/
SELECT Nombre
FROM Espacios
WHERE FloorID = 1
  AND Nombre != 'Aula';
/* 29
Lista de los tipos de componentes que tienen duracion de la garantia de las partes
del facility 1
*/
SELECT DISTINCT TipoComponente
FROM Componentes
WHERE FacilityID = 1
  AND DuracionGarantia IS NOT NULL;
/* 30
Lista de los tipos de componentes que no tiene el coste de repuesto
del facility 1
*/
SELECT DISTINCT TipoComponente
FROM Componentes
WHERE FacilityID = 1
  AND CosteRepuesto IS NULL;
/* 31
Lista de los tipos de componentes que tienen en el nombre un guión bajo
del facility 1
*/
SELECT DISTINCT TipoComponente
FROM Componentes
WHERE FacilityID = 1
  AND Nombre LIKE '%\_%' ESCAPE '\';
--
------------------------------------------------------------------------------------------------
