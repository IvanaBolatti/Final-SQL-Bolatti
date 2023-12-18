CREATE SCHEMA biblioteca;
USE biblioteca;
SET SQL_SAFE_UPDATES = 0;
-- -----------------------Tablas de biblioteca escolar ----------------------------------------

CREATE TABLE editorial(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    contacto VARCHAR(50)
);

CREATE TABLE nacionalidad(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    nombre VARCHAR(40) NOT NULL
);

CREATE TABLE serie(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL
);

CREATE TABLE tematica(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL
);

CREATE TABLE ubicacion(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(40) NOT NULL
);

CREATE TABLE autor(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    apellido VARCHAR (25) NOT NULL,
    id_nacionalidad INT NOT NULL,
    FOREIGN KEY (id_nacionalidad) REFERENCES nacionalidad (id),
    fecha_nacim DATE NOT NULL
);

CREATE TABLE NEW_AUTOR(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    apellido VARCHAR (24) NOT NULL,
    id_nacionalidad INT NOT NULL,
    FOREIGN KEY (id_nacionalidad) REFERENCES nacionalidad (id),
    fecha_nacim DATE NOT NULL
);

CREATE TABLE NEW_AUTOR_MAYOR(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    apellido VARCHAR (25) NOT NULL,
    id_nacionalidad INT NOT NULL,
    FOREIGN KEY (id_nacionalidad) REFERENCES nacionalidad (id)
);

CREATE TABLE ilustrador(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    apellido VARCHAR (25) NOT NULL,
    id_nacionalidad INT NOT NULL,
    FOREIGN KEY (id_nacionalidad) REFERENCES nacionalidad (id),
    fecha_nacim DATE NOT NULL
);


CREATE TABLE lector(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    nombre VARCHAR(25) NOT NULL, 
    apellido VARCHAR(25) NOT NULL,
    contacto VARCHAR(50),
    fecha_nac DATE NOT NULL
);

CREATE TABLE libro(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(40) NOT NULL,
    id_autor INT NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES autor (id),
    id_ilustrador INT NOT NULL,
    FOREIGN KEY (id_ilustrador) REFERENCES ilustrador (id),
    id_editorial INT NOT NULL,
    FOREIGN KEY (id_editorial) REFERENCES editorial (id),
    id_tematica INT NOT NULL,
    FOREIGN KEY (id_tematica) REFERENCES tematica (id),
    id_serie INT NOT NULL,
    FOREIGN KEY (id_serie) REFERENCES serie (id),
    detalle VARCHAR(50),
    edad INT
);


CREATE TABLE ejemplar (
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_libro INT NOT NULL,
FOREIGN KEY (id_libro) REFERENCES libro (id),
id_ubicacion INT NOT NULL,
FOREIGN KEY (id_ubicacion) REFERENCES ubicacion (id),
estado VARCHAR(20) NOT NULL
);

CREATE TABLE prestamo (
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_ejemplar INT NOT NULL,
FOREIGN KEY (id_ejemplar) REFERENCES ejemplar (id),
id_lector INT NOT NULL,
FOREIGN KEY (id_lector) REFERENCES lector (id),
f_pedido DATE NOT NULL,
f_devolucion DATE,
detalle VARCHAR(60)
);

CREATE TABLE NEW_PRESTAMO (
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_ejemplar INT NOT NULL,
FOREIGN KEY (id_ejemplar) REFERENCES ejemplar (id),
id_lector INT NOT NULL,
FOREIGN KEY (id_lector) REFERENCES lector (id),
f_pedido DATE NOT NULL,
f_devolucion DATE,
detalle VARCHAR(60)
);

-- --------------------------------Triggers----------------------------------------

-- Antes de registrar el prestamo verifica que el libro este en estado activo y modifica el estado a prestado-------
DELIMITER //
CREATE TRIGGER verificar_existencia_ejemplar
BEFORE INSERT ON prestamo
FOR EACH ROW
BEGIN
if  (SELECT buscar_estado_ejemplar(NEW.id_ejemplar))="activo" then
 INSERT INTO NEW_PRESTAMO (id, id_ejemplar, id_lector, f_pedido, f_devolucion, detalle) VALUES (NEW.id, NEW.id_ejemplar, NEW.id_lector, NEW.f_pedido,NEW.f_devolucion,NEW.detalle);
 CALL modificar_estado_ejemplar(NEW.id_ejemplar, "prestado");
end if;
END //

CREATE TRIGGER alta_autor
AFTER INSERT ON autor
FOR EACH ROW
INSERT INTO NEW_AUTOR (id, nombre, apellido, id_nacionalidad, fecha_nacim) VALUES (NEW.id, NEW.nombre, NEW. apellido, NEW.id_nacionalidad, NEW.fecha_nacim);

CREATE TRIGGER alta_lector
AFTER INSERT ON lector
FOR EACH ROW
INSERT INTO NEW_LECTOR (id, nombre, apellido, fecha_nac) VALUES (NEW.id, NEW.nombre, NEW. apellido, NEW.fecha_nac);

-- Verifica la edad de los lectores antes de almacenar la información-----
DELIMITER //
CREATE TRIGGER verificar_edad_lector
BEFORE INSERT ON lector
FOR EACH ROW
BEGIN
if  (YEAR(new.fecha_nac)< 2000) then
 INSERT INTO NEW_LECTOR_MAYOR (id, nombre, apellido, fecha_nac) VALUES (NEW.id, NEW.nombre, NEW.apellido, NEW.fecha_nac);
end if;
END //

-- Insert date ------------------------------------------------------------------------------

INSERT INTO nacionalidad VALUES 
(NULL,"argentino"),
(NULL,"brasilero"),
(NULL,"peruano"),
(NULL,"mexicano");

INSERT INTO ubicacion VALUES 
(NULL,"zona verde"),
(NULL,"zona azul"),
(NULL,"zona amarilla"),
(NULL,"zona roja");

INSERT INTO autor VALUES 
(NULL,"Juan","Carlos", 2, '1987/12/13'),
(NULL,"Pedro","Alfonso", 1, '1978/02/17'),
(NULL,"Raúl","Perez", 2, '1987/08/06'),
(NULL,"Roberto","Segura", 4, '1984/07/30'),
(NULL,"Romina","Moyano", 1, '1967/05/13'),
(NULL,"Teresa","Perez", 3, '971/09/14'),
(NULL,"Tamara","Martinez", 2, '1965/12/23'),
(NULL,"Carolina","Colorado", 1, '1970/02/21'),
(NULL,"Tania","Cabas", 2, '1975/08/08'),
(NULL,"Maria","Recalde", 4, '1984/07/30'),
(NULL,"Camilo","Gomez", 1, '1967/05/13'),
(NULL,"Nicolas","Milanes", 3, '971/09/14');

INSERT INTO prestamo VALUES 
(NULL, 18, 2, '2023/12/13',null ," detalle 1"),
(NULL, 13, 1, '2023/02/17', null, "detalle 2"),
(NULL,16, 2, '2023/08/06', null,"detalle 3"),
(NULL,19, 4, '2023/07/30', null," detalle 4");

-- Prueba para verificar que no registre el prestamo porque el libro esta prestado---
INSERT INTO prestamo VALUES 
(NULL, 33, 2, '2023/12/13',null ," detalle 1"),
(NULL, 16, 1, '2023/02/17', null, "detalle 2");
(NULL,13, 2, '2023/08/06', null,"detalle 3"),
(NULL,26, 4, '2023/07/30', null," detalle 4");

select * FROM editorial;
select * FROM ilustrador;
select * FRom autor;
select * from ejemplar;
select * from prestamo;

-- ----------------------------View -----------------------------------------------------

CREATE OR REPLACE VIEW autores_argentinos AS 
(SELECT a.nombre, a.apellido FROM autor a  JOIN nacionalidad n on a.id_nacionalidad="2");

CREATE OR REPLACE VIEW autores_nacionalidad AS
(SELECT a.apellido, n.nombre FROM autor a JOIN nacionalidad n ON a.id_nacionalidad=n.id);

CREATE OR REPLACE VIEW ejemplar_perdidos AS 
(SELECT * FROM  ejemplar WHERE estado LIKE "perdido");

-- Listado de libros que han sido seleccionados por los lectores---------------
CREATE  OR REPLACE VIEW libros_elegidos AS
(SELECT l.id, l.titulo FROM libro l INNER JOIN prestamo p JOIN ejemplar e on e.id=p.id_ejemplar and e.id_libro=l.id);

CREATE VIEW series AS 
SELECT s.id, s.nombre FROM serie s;

CREATE OR REPLACE VIEW tematicas AS 
SELECT t.nombre FROM tematica t;

-- ---------------------------Functions -------------------------------------------------------

DELIMITER //
CREATE FUNCTION buscar_autor (clave int)
RETURNS varchar(20)
DETERMINISTIC
BEGIN
DECLARE nombre_encontrado VARCHAR (20);
SET nombre_encontrado="inexistente";
SELECT autor.nombre INTO nombre_encontrado FROM autor WHERE autor.id=clave;
RETURN nombre_encontrado;
END//

DELIMITER //
CREATE FUNCTION buscar_lector (clave int)
RETURNS varchar(30)
DETERMINISTIC
BEGIN
DECLARE nombre_encontrado VARCHAR (30);
SET nombre_encontrado="inexistente";
SELECT CONCAT (lector.nombre," ", lector.apellido) INTO nombre_encontrado FROM lector WHERE lector.id=clave;
RETURN nombre_encontrado;
END//

SELECT buscar_autor(9);
SELECT buscar_lector(1);

DELIMITER //
CREATE FUNCTION buscar_estado_ejemplar (clave int)
RETURNS varchar(20)
DETERMINISTIC
BEGIN
DECLARE estado_encontrado VARCHAR (20);
SET estado_encontrado="inexistente";
SELECT ejemplar.estado into estado_encontrado FROM ejemplar WHERE ejemplar.id=clave;
RETURN estado_encontrado;
END//

SELECT buscar_estado_ejemplar(18);
select * from ejemplar;


DELIMITER //
CREATE FUNCTION buscar_id_autor (nombre varchar (20), apellido varchar (20))
RETURNS int
DETERMINISTIC
BEGIN
DECLARE clave int;
SET clave=0;
SELECT a.id into clave FROM autor a WHERE a.nombre=nombre and a.apellido=apellido;
RETURN clave;
END//

DELIMITER //
CREATE FUNCTION buscar_id_lector (nombre varchar (20), apellido varchar (20))
RETURNS int
DETERMINISTIC
BEGIN
DECLARE clave int;
SET clave=0;
SELECT l.id into clave FROM lector l WHERE l.nombre=nombre and l.apellido=apellido;
RETURN clave;
END//

SELECT buscar_id_lector ("Zola", "Click");
select * from lector;

-- Determina la edad de los lectores-----------------
DELIMITER //
CREATE FUNCTION edad (fecha DATE)
RETURNS int
DETERMINISTIC
BEGIN
DECLARE edad int;
SET edad=YEAR(NOW()) - YEAR(fecha);
RETURN edad;
END//


-- Informa el rango de edad en la cual se encuentra el lector de la institución---
-- Utiliza la función para determinar la edad.
DELIMITER //
CREATE FUNCTION rango_edad_lector (edad int)
RETURNS varchar(20)
DETERMINISTIC
BEGIN
DECLARE rango VARCHAR (20);
SET rango=" ";
CASE 
WHEN edad <=12 THEN RETURN "menor de 12";
WHEN edad >12 AND edad <19 THEN RETURN "entre 12 y 19";
WHEN edad >19 THEN RETURN "mayor a 19";
ELSE  RETURN "No se encuentra";
END CASE;
RETURN rango;
END//

SELECT l.nombre, l.apellido, rango_edad_lector(edad(l.fecha_nac)) FROM lector l;
SELECT l.nombre, l.apellido, edad(l.fecha_nac) FROM lector l;

-- ----------------------------Procedures----------------------------------------------------

DELIMITER //
CREATE PROCEDURE buscar_ejemplares_libro (IN clave int)
DETERMINISTIC
BEGIN
SELECT e.id, l.titulo, e.estado FROM libro l JOIN ejemplar e ON l.id=e.id_libro WHERE clave=l.id;
END//

CALL buscar_ejemplares_libro(32);

-- Cuando se realiza un préstamo o cuando se devuelve un libro- ejemplar- se actualiza el estado-------
DELIMITER //
CREATE PROCEDURE modificar_estado_ejemplar (IN clave int, IN estado VARCHAR(20))
DETERMINISTIC
BEGIN
UPDATE ejemplar e SET e.estado=estado WHERE clave=e.id; 
END//

-- Cuando se devuelve un libro-ejemplar- se registra la fecha de devolución y se llama al procedure que modifica el estado del libro-ejemplar.
DELIMITER //
CREATE PROCEDURE registrar_devolucion (IN clave int, IN fecha date)
DETERMINISTIC
BEGIN
DECLARE clave_ejemplar INT;
SET clave_ejemplar=(SELECT p.id_ejemplar FROM prestamo p WHERE clave=p.id);
CALL modificar_estado_ejemplar(clave_ejemplar, "activo");
UPDATE prestamo p SET p.f_devolucion=fecha WHERE clave=p.id; 
END//

select * from prestamo;
CALL registrar_devolucion(13,"2023/12/11");

-- A partir del id del lector se buscan los prestamos que están activos
DELIMITER //
CREATE  PROCEDURE lector_prestamo(IN id_lector int)
DETERMINISTIC
BEGIN
SELECT l.id, l.nombre, l.apellido, p.id, p.id_ejemplar, p.f_devolucion 
FROM lector l JOIN prestamo p on id_lector=p.id_lector and p.id_lector=l.id;
END//
select * from prestamo;
CALL lector_prestamo(2);

-- Ordena los registros de autores según el campo ingresado
DELIMITER //
CREATE PROCEDURE ordenar_autores (IN campo char(20))
BEGIN
if campo<>' ' then
  SET  @orden= CONCAT ('ORDER BY ', campo);
  ELSE 
    SET @orden=' ';
 END IF;
 
 SET @clausula= CONCAT ('SELECT * FROM autor ', @orden );
 PREPARE runSQL FROM @clausula;
 EXECUTE runSQL;
 DEALLOCATE PREPARE runSQL;
 END
 //
 
 CALL ordenar_autores('nombre');

DELIMITER //
CREATE PROCEDURE eliminar_autor (IN id_eliminar int)
BEGIN
 DELETE FROM autor WHERE autor.id=id_eliminar
 LIMIT 1;
 END
 //

CALL eliminar_autor (4);

DELIMITER //
CREATE PROCEDURE eliminar_lector (IN id_eliminar int)
BEGIN
 DELETE FROM lector WHERE lector.id=id_eliminar
 LIMIT 1;
 END
 //

