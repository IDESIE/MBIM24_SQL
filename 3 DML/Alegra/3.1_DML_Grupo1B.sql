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
insert into components (
    name,
    description,
    serial_number,
    installation_date,
    warranty_start_date,
    asset_code,
    creator_id,
    space_id,
    typeid,
    guid
)
values (
    'Grifo | Grifo | 030303',
    'test insert',
    '666333-eeefff',
    '2021-12-12',
    '2021-11-11',
    '666000',
    3,
    7,
    78,
    '666000'
);
/*
Comprobar que se ven los datos insertados de forma conjunta con una JOIN
y no de forma independiente. Con el fin de comprobar las relaciones.
Mostrar todos los datos indicados en el punto anterior 
y además el nombre del espacio, nombre de la planta, nombre del tipo de componente
*/
select
    components.name,
    components.description,
    components.serial_number,
    components.installation_date,
    components.warranty_start_date,
    components.asset_code,
    components.creator_id,
    components.space_id,
    components.typeid,
    components.guid,
    spaces.name,
    floors.name,
    component_types.name
from
    components
    join spaces on components.space_id = spaces.id
    join floors on spaces.floor_id = floors.id
    join component_types on components.typeid = component_types.id
where
    components.guid = '666000';
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
set barcode = substr(guid, length(guid) - 5, 6)
where space_id in (
    select spaces.id
    from spaces
    join floors on spaces.floor_id = floors.id
    join facilities on floors.facility_id = facilities.id
    where facilities.id = 1
    and floors.id in (1, 2)
);
/* 4
Modificar la fecha de garantia para que sea igual a la fecha de instalación
para todo componente que sea un grifo o lavabo del facility 1.
*/
update components
set warranty_start_date = installation_date
where typeid in (
    select component_types.id
    from component_types
    where component_types.name in ('Grifo', 'Lavabo')
)
and space_id in (
    select spaces.id
    from spaces
    join floors on spaces.floor_id = floors.id
    join facilities on floors.facility_id = facilities.id
    where facilities.id = 1
);
/* 5
Anonimizar los datos personales: nombre, apellido, email, teléfono de los contactos
*/
update contacts
set
    first_name = 'Anon',
    last_name = 'Anon',
    email = concat('anon', id, '@anon.com'),
    phone = '000000000';