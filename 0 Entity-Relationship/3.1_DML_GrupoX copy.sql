------------------------------------------------------------------------------------------------
-- DML
------------------------------------------------------------------------------------------------
/* 1
Insertar un componente en el facility 1 
con nombre «Grifo | Grifo | 030303» 
descripcion «test insert»
número de serie «666333-eeefff»
fecha de instalación «2021-12-12»
inicio de garantia «2021-11-11»
código de activo «666000»
id del creador «3»
id del espacio «7»
id de tipo «78»
guid «666000»
*/
insert into components (name, description, serialnumber, installatedon, warrantystart, assetidentifier, creatorid, spaceid, typeid, guid)
values ('Grifo | Grifo | 030303', 'test insert', '666333-eeefff', '2021-12-12', '2021-11-11', '666000', 3, 7, 78, '666000');
/*
Comprobar que se ven los datos insertados de forma conjunta con una JOIN
y no de forma independiente. Con el fin de comprobar las relaciones.
Mostrar todos los datos indicados en el punto anterior 
y además el nombre del espacio, nombre de la planta, nombre del tipo de componente
*/
select c.name as "component name", c.description, c.serialnumber, c.installatedon, c.warrantystart, c.assetidentifier, c.creatorid, c.spaceid, c.typeid, c.guid,
       s.name as "space name", fl.name as "floor name", ct.name as "component type"
from components c
join spaces s on c.spaceid = s.id
join floors fl on s.floorid = fl.id
join component_types ct on c.typeid = ct.id
where c.guid = '666000';

/* 2
Eliminar el componente creado.
*/
delete from components
where guid = '666000';

/* 3
Colocar como código de barras los 6 últimos caracteres del GUID 
a todo componente de la planta 1 y 2 del facility 1.
*/
update components
set barcode = right(guid, 6)
where spaceid in (select id from spaces where floorid in (select id from floors where facilityid = 1 and id in (1, 2)));

/* 4
Modificar la fecha de garantia para que sea igual a la fecha de instalación
para todo componente que sea un grifo o lavabo del facility 1.
*/
update components
set warrantystart = installatedon
where spaceid in (select id from spaces where floorid in (select id from floors where facilityid = 1))
and (name like '%grifo%' or name like '%lavabo%');
/* 5
Anonimizar los datos personales: nombre, apellido, email, teléfono de los contactos
*/
update contacts
set first_name = 'Anonymous', last_name = 'Anonymous', email = 'anonymous@example.com', phone = '000000000'
where first_name is not null and last_name is not null;
