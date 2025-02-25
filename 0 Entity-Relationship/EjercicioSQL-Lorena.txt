/* 1
Describir la tabla floors
*/
desc floors;
/* 2
Describir la tabla spaces
*/
desc spaces
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
select id,name
from facilities;
/* 6
Nombre, elevación e id del facility de las plantas
*/
select name, elevation,facilityid
from floors;
/* 7
Nombre, area bruta, volumen de los espacios
*/
select name, netarea,volume
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
    and name = 'Planta +1';
select name, floorid
from spaces
where floorid= 1;
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
select name, installatedon
from components
where spaceid = 60
order  by installatedon desc;

/* 12
Listar las distintas fechas de instalación de los componentes del facility 1 ordenados descendentemente.
*/
select distinct installatedon
from components
where facilityid = 1
order  by installatedon desc;

/* 13
Listar los distintos GUIDs de los componentes del facility 1 ordenados ascendentemente por fecha de garantía.
*/
select distinct externalidentifier
from components
where facilityid = 1
order  by warrantystarton asc;
/* 14
Id, código de activo, GUID, número de serie y nombre de los componentes cuyo spaceid está entre 10 y 27 inclusive
ordenados por id de espacio descendentemente.
*/
select id, assetidentifier, externalidentifier, serialnumber, name
from components
where spaceid <= 27 AND spaceid >= 10
order  by spaceid desc;
/* 15
Id, código de activo, GUID, número de serie y nombre de los componentes del facility 1 
ordenados por código de activo descendentemente.
*/
select id, assetidentifier, externalidentifier, serialnumber, name
from components
where facilityid=1
order  by assetidentifier desc;
/* 16
Códigos de activo de los componentes del espacio con id 21
ordenados por código de activo descendentemente.
*/
select assetidentifier
from components
where spaceid=21
order  by assetidentifier desc;