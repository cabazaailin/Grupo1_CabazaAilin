-- --------------
-- FBD-111
-- Grupo 1
-- Diseño lógico y físico
-- Integrantes: Ailin Melani Cabaza Mayta
-- -----------------

-- Problema: una universidad necesita controlar las reservas de salas y espacios académicos

CREATE DATABASE IF NOT EXISTS reservas_salas
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE reservas_salas;


DROP TABLE IF EXISTS reserva;
DROP TABLE IF EXISTS sala;
DROP TABLE IF EXISTS docente;



-- Tabla docente
-- Guarda los datos de cada docente. Clave primaria: id_docente
CREATE TABLE docente (
    id_docente   INT          NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(100) NOT NULL,
    correo       VARCHAR(100) NOT NULL,
    departamento VARCHAR(80)  NOT NULL,
    CONSTRAINT pk_docente PRIMARY KEY (id_docente),
    -- UNIQUE: no pueden existir dos docentes con el mismo correo
    CONSTRAINT uq_docente_correo UNIQUE (correo)
);

-- Tabla sala

CREATE TABLE sala (
    id_sala   INT         NOT NULL AUTO_INCREMENT,
    nombre    VARCHAR(60) NOT NULL,
    capacidad INT         NOT NULL,
    tipo      VARCHAR(30) NOT NULL,
    estado    VARCHAR(20) NOT NULL DEFAULT 'Disponible',
    CONSTRAINT pk_sala PRIMARY KEY (id_sala),
    -- UNIQUE: no pueden existir dos salas con el mismo nombre
    CONSTRAINT uq_sala_nombre UNIQUE (nombre),
    -- CHECK: la capacidad debe ser mayor a 0
    CONSTRAINT ck_sala_capacidad CHECK (capacidad > 0),
    -- CHECK: el estado solo puede tener uno de estos valores
    CONSTRAINT ck_sala_estado CHECK (estado IN ('Disponible', 'Mantenimiento', 'Inactiva'))
);

-- Tabla reserva
-- Une a un docente con una sala en una fecha y horario.
-- Clave primaria: id_reserva
-- Claves foráneas: id_docente (hacia docente) e id_sala (hacia sala)
CREATE TABLE reserva (
    id_reserva  INT          NOT NULL AUTO_INCREMENT,
    id_docente  INT          NOT NULL,
    id_sala     INT          NOT NULL,
    fecha       DATE         NOT NULL,
    hora_inicio TIME         NOT NULL,
    hora_fin    TIME         NOT NULL,
    motivo      VARCHAR(150) NOT NULL,
    CONSTRAINT pk_reserva PRIMARY KEY (id_reserva),
    -- Clave foránea hacia docente: no se puede reservar con un docente que no existe
    CONSTRAINT fk_reserva_docente FOREIGN KEY (id_docente)
        REFERENCES docente (id_docente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    -- Clave foránea hacia sala: no se puede reservar una sala que no existe
    CONSTRAINT fk_reserva_sala FOREIGN KEY (id_sala)
        REFERENCES sala (id_sala)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    -- CHECK: la hora de fin debe ser después de la hora de inicio
    CONSTRAINT ck_reserva_horario CHECK (hora_fin > hora_inicio),
    -- UNIQUE: una sala no puede tener dos reservas el mismo día a la misma hora de inicio
    CONSTRAINT uq_reserva_sala_horario UNIQUE (id_sala, fecha, hora_inicio)
);




-- Datos de docentes (6)
INSERT INTO docente (id_docente, nombre, correo, departamento) VALUES
    (1, 'Carla Mamani Quispe',     'carla.mamani@universidad.edu.bo',     'Sistemas'),
    (2, 'Roberto Fernández Rojas', 'roberto.fernandez@universidad.edu.bo', 'Matemática'),
    (3, 'Lucía Vargas Choque',     'lucia.vargas@universidad.edu.bo',     'Ciencias Empresariales'),
    (4, 'Marco Flores Gutiérrez',  'marco.flores@universidad.edu.bo',     'Sistemas'),
    (5, 'Patricia Condori Lima',   'patricia.condori@universidad.edu.bo', 'Idiomas'),
    (6, 'Javier Mendoza Arce',     'javier.mendoza@universidad.edu.bo',   'Matemática');


-- La sala 1 tiene capacidad 30 
INSERT INTO sala (id_sala, nombre, capacidad, tipo, estado) VALUES
    (1, 'Aula 101',                    30,  'Aula',             'Disponible'),
    (2, 'Aula 205',                    40,  'Aula',             'Disponible'),
    (3, 'Laboratorio de Computación 1', 35, 'Laboratorio',      'Disponible'),
    (4, 'Auditorio Central',           120, 'Auditorio',        'Disponible'),
    (5, 'Laboratorio de Computación 2', 25, 'Laboratorio',      'Disponible'),
    (6, 'Sala de Reuniones B',         12,  'Sala de reuniones', 'Mantenimiento');


INSERT INTO reserva (id_reserva, id_docente, id_sala, fecha, hora_inicio, hora_fin, motivo) VALUES
    (1,  1, 3, '2026-10-05', '08:00:00', '10:00:00', 'Práctica de programación'),
    (2,  1, 3, '2026-10-07', '10:00:00', '12:00:00', 'Taller de bases de datos'),
    (3,  2, 2, '2026-10-05', '10:00:00', '12:00:00', 'Clase de cálculo'),
    (4,  3, 4, '2026-10-08', '15:00:00', '17:00:00', 'Conferencia de emprendimiento'),
    (5,  4, 3, '2026-10-06', '14:00:00', '16:00:00', 'Laboratorio de redes'),
    (6,  5, 1, '2026-10-06', '09:00:00', '11:00:00', 'Clase de inglés técnico'),
    (7,  2, 2, '2026-10-09', '08:00:00', '10:00:00', 'Examen parcial de matemática'),
    (8,  3, 4, '2026-10-12', '09:00:00', '11:00:00', 'Charla de ética empresarial'),
    (9,  4, 5, '2026-10-07', '16:00:00', '18:00:00', 'Reforzamiento de programación'),
    (10, 1, 4, '2026-10-12', '14:00:00', '16:00:00', 'Presentación de proyectos integradores'),
    (11, 5, 4, '2026-10-08', '10:00:00', '12:00:00', 'Feria de idiomas'),
    (12, 2, 1, '2026-10-05', '08:00:00', '10:00:00', 'Tutoría de álgebra');

-- Se revisa que los datos se hayan guardado bien
SELECT * FROM docente;
SELECT * FROM sala;
SELECT * FROM reserva;



-- Une las 3 tablas con JOIN para ver en una sola tabla quién reservó,

SELECT
    d.nombre       AS docente,
    d.departamento AS departamento,
    s.nombre       AS sala,
    s.tipo         AS tipo_sala,
    s.capacidad    AS capacidad,
    r.fecha        AS fecha,
    r.hora_inicio  AS hora_inicio,
    r.hora_fin     AS hora_fin,
    r.motivo       AS motivo
FROM reserva r
INNER JOIN docente d ON r.id_docente = d.id_docente
INNER JOIN sala s    ON r.id_sala = s.id_sala
ORDER BY r.fecha, r.hora_inicio;



-- Muestra qué reservas hizo cada departamento a través de sus docentes.
SELECT
    d.departamento AS departamento,
    d.nombre       AS docente,
    s.nombre       AS sala,
    r.fecha        AS fecha,
    r.motivo       AS motivo
FROM reserva r
INNER JOIN docente d ON r.id_docente = d.id_docente
INNER JOIN sala s    ON r.id_sala = s.id_sala
ORDER BY d.departamento, d.nombre, r.fecha;



-- Cuenta cuántas reservas tiene cada sala.

SELECT
    s.nombre                AS sala,
    COUNT(r.id_reserva)     AS total_reservas
FROM sala s
LEFT JOIN reserva r ON s.id_sala = r.id_sala
GROUP BY s.id_sala, s.nombre
ORDER BY s.nombre;



-- Con INNER JOIN no aparecen los docentes que no tienen reservas.
SELECT
    d.nombre            AS docente,
    d.departamento      AS departamento,
    COUNT(r.id_reserva) AS total_reservas
FROM docente d
INNER JOIN reserva r ON d.id_docente = r.id_docente
GROUP BY d.id_docente, d.nombre, d.departamento
ORDER BY total_reservas DESC, d.nombre;


-- WHERE filtra las salas
SELECT
    s.nombre    AS sala,
    s.capacidad AS capacidad,
    d.nombre    AS docente,
    r.fecha     AS fecha,
    r.motivo    AS motivo
FROM reserva r
INNER JOIN sala s    ON r.id_sala = s.id_sala
INNER JOIN docente d ON r.id_docente = d.id_docente
WHERE s.capacidad > 30
ORDER BY s.capacidad DESC, r.fecha;



-- Relaciona docente - reserva - sala. Para otra fecha, solo se cambia el valor del WHERE.
SELECT
    r.fecha       AS fecha,
    r.hora_inicio AS hora_inicio,
    r.hora_fin    AS hora_fin,
    d.nombre      AS docente,
    s.nombre      AS sala,
    r.motivo      AS motivo
FROM docente d
INNER JOIN reserva r ON d.id_docente = r.id_docente
INNER JOIN sala s    ON r.id_sala = s.id_sala
WHERE r.fecha = '2026-10-05'
ORDER BY r.hora_inicio;


SELECT
    s.nombre            AS sala,
    COUNT(r.id_reserva) AS total_reservas
FROM sala s
INNER JOIN reserva r ON s.id_sala = r.id_sala
GROUP BY s.id_sala, s.nombre
ORDER BY total_reservas DESC, s.nombre;

SELECT
    d.departamento AS departamento,
    s.tipo         AS tipo_sala,
    COUNT(r.id_reserva) AS total_reservas,
    ROUND(SUM(TIME_TO_SEC(TIMEDIFF(r.hora_fin, r.hora_inicio))) / 3600, 1) AS horas_de_uso
FROM reserva r
INNER JOIN docente d ON r.id_docente = d.id_docente
INNER JOIN sala s    ON r.id_sala = s.id_sala
WHERE s.estado = 'Disponible'
GROUP BY d.departamento, s.tipo
ORDER BY horas_de_uso DESC, d.departamento;
