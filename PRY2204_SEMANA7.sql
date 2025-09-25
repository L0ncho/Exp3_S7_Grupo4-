--CASO 1 : CREACION DE TABLAS

-- Tabla region autoincrementable
CREATE TABLE REGION (
id_region NUMBER(2) GENERATED ALWAYS AS IDENTITY (START WITH 7 INCREMENT BY 2),
nombre_region VARCHAR(25),
CONSTRAINT REGION_PK PRIMARY KEY (id_region)

);

-- Tabla estado_civil
CREATE TABLE ESTADO_CIVIL(
id_est_civil VARCHAR(2),
descripcion_est_civil VARCHAR(25),
CONSTRAINT ESTADO_CIVIL_PK PRIMARY KEY (id_est_civil)
);

--Tabla GENERO
CREATE TABLE GENERO(
id_genero VARCHAR2(3),
descrip_genero VARCHAR(25),
CONSTRAINT GENERO_PK PRIMARY KEY (id_genero)
);

-- Tabla TITULO
CREATE TABLE TITULO(
id_titulo VARCHAR(2),
descrip_titulo VARCHAR2(60),
CONSTRAINT TITULO_PK PRIMARY KEY (id_titulo)
);

--Tabla IDIOMA
CREATE TABLE IDIOMA(
id_idioma NUMBER (3) GENERATED ALWAYS AS IDENTITY (START WITH 25 INCREMENT BY 3),
nombre_idioma VARCHAR2(30),
CONSTRAINT IDIOMA_PK PRIMARY KEY (id_idioma)
);


--Tabla COMUNA
CREATE TABLE COMUNA(
id_comuna NUMBER(5),
comuna_nombre VARCHAR2(25),
cod_region NUMBER(2),
CONSTRAINT COMUNA_PK PRIMARY KEY (id_comuna, cod_region),
CONSTRAINT COMUNA_FK_REGION FOREIGN KEY (cod_region)
REFERENCES REGION(id_region)
);

-- SECUENCIA
CREATE SEQUENCE COMUNA_SEQ
START WITH 1101
INCREMENT BY 6;
/* TIGGER QUE SE EJECUTA ANTES DE INSTERAR UN NUEVO VALOR, no es necesario, pero facilita la insercion de datos
CREATE OR REPLACE TRIGGER COMUNA_TRG
BEFORE INSERT ON COMUNA
FOR EACH ROW
BEGIN
: NEW.id_comuna := COMUNA_SEQ.NEXTVAL;
END;
*/

--Tabla COMPANIA
CREATE TABLE COMPANIA(
id_empresa NUMBER(2),
nombre_empresa VARCHAR2(25),
calle VARCHAR2 (50),
numeracion NUMBER(5),
renta_promedio NUMBER(10),
pct_aumento NUMBER(4,3),
cod_comuna NUMBER(5),
cod_region NUMBER(2),
CONSTRAINT COMPANIA_PK PRIMARY KEY (id_empresa),
CONSTRAINT COMPANIA_UN_NOMBRE UNIQUE (nombre_empresa),
CONSTRAINT COMPANIA_FK_COMUNA FOREIGN KEY (cod_comuna, cod_region)
REFERENCES COMUNA(id_comuna, cod_region)
);

--secuencia para compania
CREATE SEQUENCE COMPANIA_SQE
START WITH 10
INCREMENT BY 5;

--Tabla PERSONAL
CREATE TABLE PERSONAL (
rut_persona NUMBER (8),
dv_persona CHAR(1),
primer_nombre VARCHAR2(25),
segundo_nombre VARCHAR(25),
primer_apellido VARCHAR2(25),
segundo_apellido VARCHAR2(25),
fecha_contratacion DATE,
fecha_nacimiento DATE,
email VARCHAR2(100),
calle VARCHAR2(50),
numeracion NUMBER(5),
sueldo NUMBER (5),
cod_comuna NUMBER(5),
cod_region NUMBER(2),
cod_genero VARCHAR2(3),
cod_est_civil VARCHAR2(2),
cod_empresa NUMBER(2),
encargado_rut NUMBER (8),
CONSTRAINT PERSONAL_PK PRIMARY KEY (rut_persona),
CONSTRAINT PERSONAL_FK_COMPANIA FOREIGN KEY (cod_empresa)
REFERENCES COMPANIA(id_empresa),
CONSTRAINT PERSONAL_FK_COMUNA FOREIGN KEY (cod_comuna, cod_region)
REFERENCES COMUNA(id_comuna, cod_region),
CONSTRAINT PERSONAL_FK_GENERO FOREIGN KEY (cod_genero)
REFERENCES GENERO(id_genero),
CONSTRAINT PERSONAL_FK_ESTADO_CIVIL FOREIGN KEY (cod_est_civil)
REFERENCES ESTADO_CIVIL(id_est_civil),
CONSTRAINT PERSONAL_PERSONAL_FK FOREIGN KEY (encargado_rut)
REFERENCES PERSONAL(rut_persona)
);

--Tabla TITULACION
CREATE TABLE TITULACION(
cod_titulo VARCHAR2(3),
persona_rut NUMBER(8),
fecha_titulacion DATE,
CONSTRAINT TITULACION_PK PRIMARY KEY (cod_titulo, persona_rut),
CONSTRAINT TITULACION_FK_PERSONAL FOREIGN KEY (persona_rut)
REFERENCES PERSONAL (rut_persona),
CONSTRAINT TITULACION_FK_TITULO FOREIGN KEY (cod_titulo)
REFERENCES TITULO(id_titulo)
);

--Tabla DOMINIO
CREATE TABLE DOMINIO(
id_idioma NUMBER(3),
persona_rut NUMBER(8),
nivel VARCHAR2 (25),
CONSTRAINT DOMINIO_PK PRIMARY KEY (id_idioma, persona_rut),
CONSTRAINT DOMINIO_FK_IDIOMA FOREIGN KEY (id_idioma)
REFERENCES IDIOMA (id_idioma),
CONSTRAINT DOMINIO_FK_PERSONAL FOREIGN KEY (persona_rut)
REFERENCES PERSONAL (rut_persona)
);

-- CASO 2 REGLAS DE NEGOCIOS

-- MAIL OPCIONAL PERO UNICO
ALTER TABLE PERSONAL
ADD CONSTRAINT PERSONAL_EMAIL_UNICO UNIQUE (email);

--digito verificador
ALTER TABLE PERSONAL
ADD CONSTRAINT PERSONAL_CK_DV_PERSONA CHECK (dv_persona IN ('0','1','2','3','4','5','6','7','8','9','K'));

--Sueldo min
ALTER TABLE PERSONAL
ADD CONSTRAINT PERSONAL_CK_SUELDO_MIN CHECK (sueldo >= 450000);



--CASO 3: Poblamiento del modelo
-- INSERTANDO A TABLA REGION

INSERT INTO REGION (nombre_region) VALUES ('ARICA Y PARINACOTA');
INSERT INTO REGION (nombre_region) VALUES ('METROPOLITANA');
INSERT INTO REGION (nombre_region) VALUES ('LA ARAUCANIA');

--SELECT * FROM REGION; PRUEBA PARA VERIFICAR LA INSERCION EN LA TABLA REGION

-- INSERTANDO A TABLA IDIOMA
INSERT INTO IDIOMA (nombre_idioma) VALUES ('INGLES');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('CHINO');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('ALEMAN');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('ESPAÑOL');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('FRANCES');

--SELECT * FROM IDIOMA; PRUEBA PARA VERIFICAR LA INSERCION EN LA TABLA IDIOMA

--INSERTANDO A TABLA COMUNA
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (COMUNA_SEQ.NEXTVAL, 'ARICA', 7);
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (COMUNA_SEQ.NEXTVAL, 'SANTIAGO', 9);
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (COMUNA_SEQ.NEXTVAL, 'TEMUCO', 11);


-- SELECT * FROM COMUNA; PRUEBA PARA VERIFICAR LA INSERCION EN LA TABLA COMUNA

--INSERTANDO A TABLA COMPANIA

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (COMPANIA_SQE.NEXTVAL, 'CCyRojas', 'AMAPOLAS',506,1857000,0.5, 1101, 7);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (COMPANIA_SQE.NEXTVAL, 'SenTTy', 'LOS ALAMOS',3490,897000,0.025, 1101, 7);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (COMPANIA_SQE.NEXTVAL, 'Praxia LTDA', 'LAS CAMELIAS',11098,2157000,0.035, 1107, 9);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (COMPANIA_SQE.NEXTVAL, 'TIC spa', 'FLORES S.A',4537,857000,NULL, 1107, 9);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (COMPANIA_SQE.NEXTVAL, ' SANTANA LTDA', 'AVDA VIC. MACKENA',106,757000,0.015, 1101, 7);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (COMPANIA_SQE.NEXTVAL, ' FLORES Y ASOCIADOS', 'PEDRO LATORRE',557,589000,0.015, 1107, 9);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (COMPANIA_SQE.NEXTVAL, ' J.A. HOFFMAN', 'LATINA D.32',509,1857000,0.025, 1113, 11);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (COMPANIA_SQE.NEXTVAL, ' CAGLIARI D.', 'ALAMEDA',206,1857000,NULL, 1107, 9);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (COMPANIA_SQE.NEXTVAL, ' ROJAS HNOS LTDA', 'SUCRE',106,957000,0.005, 1113, 11);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (COMPANIA_SQE.NEXTVAL, ' FRIENDS P. S.A', 'SUECIA',506,857000,0.015, 1113, 11);

-- SELECT * FROM COMPANIA;PRUEBA PARA VERIFICAR LA INSERCION EN LA TABLA COMPANIA

--CASO 4: RECUPERACION DE DATOS

--INFORME 1: quedaron los nombres un poco corridos, es por que en el insert, deje un espacio xd

SELECT
    nombre_empresa AS "Nombre Empresa",
    calle || ' ' || numeracion AS "Direccion",
    renta_promedio AS "Renta Promedio",
    renta_promedio * ( 1 + pct_aumento) AS "Simulacion de renta"
FROM
    COMPANIA
ORDER BY 
    "Renta Promedio" DESC,
    "Simulacion de renta" ASC;
    
--INFORME 2:

SELECT
    id_empresa AS "CODIGO",
    nombre_empresa AS "EMPRESA",
    renta_promedio AS "PROM RENTA ACTUAL",
    renta_promedio + 0.15 AS "PCT AUMENTADO EN 15%",
    renta_promedio +(1 +(pct_aumento + 0.15 )) AS "RENTA AUMENTADA"
FROM
    COMPANIA
ORDER BY
    "PROM RENTA ACTUAL" ASC,
    "EMPRESA" DESC;
    