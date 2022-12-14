/* Eliminar el esquema y los datos actuales */
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

DROP TABLE IF EXISTS contacts;
DROP TABLE IF EXISTS customers;

/* TABLA VIVERO
   Vivero donde se cultivan los productos.

   - ID Vivero (clave primaria)
   - Localización vivero
   - Superficie en m^2
*/
CREATE TABLE VIVERO(
    ID_VIVERO INT NOT NULL,
    LOCALIZACION VARCHAR(50) NOT NULL,
    SUPERFICIE INT NOT NULL,
    PRIMARY KEY(ID_VIVERO)
);

/* TABLA ZONA
   Zona dentro de un vivero determinado.

   - ID Zona (clave primaria)
   - ID Vivero (clave ajena y primaria)
   - Localización zona
   - Productividad
*/
CREATE TABLE ZONA(
    ID_ZONA INT NOT NULL,
    ID_VIVERO INT NOT NULL,
    LOCALIZACION VARCHAR(25),
    PRODUCTIVIDAD INT,
    PRIMARY KEY (ID_ZONA, ID_VIVERO),
    CONSTRAINT fk_idvivero
        FOREIGN KEY(ID_VIVERO)
            REFERENCES VIVERO(ID_VIVERO)
                ON DELETE CASCADE
);

/* TABLA EMPLEADO
   Empleado de la empresa.

   - DNI (clave primaria)
   - Nombre
   - Productividad
   - Objetivos
*/
CREATE TABLE EMPLEADO(
    DNI VARCHAR(9) NOT NULL,
    NOMBRE VARCHAR(20) NOT NULL,
    PRODUCTIVIDAD INT,
    OBJETIVOS INT,
    PRIMARY KEY(DNI)
);

/* TABLA RESPONSABLE
   Relaciona una zona con un empleado.

   - DNI (clave ajena y primaria)
   - ID Zona (clave ajena y primaria)
   - ID Vivero (clave ajena)
   - Época
*/
CREATE TABLE RESPONSABLE(
    DNI VARCHAR(9) NOT NULL,
    ID_VIVERO INT NOT NULL,
    ID_ZONA INT NOT NULL,
    EPOCA DATE NOT NULL,
    PRIMARY KEY (DNI, ID_ZONA, ID_VIVERO),
    CONSTRAINT fk_dni
        FOREIGN KEY (DNI)
            REFERENCES EMPLEADO(DNI)
                ON DELETE CASCADE,
    CONSTRAINT fk_zona_vivero
        FOREIGN KEY (ID_ZONA, ID_VIVERO)
            REFERENCES ZONA(ID_ZONA, ID_VIVERO)
                ON DELETE CASCADE
);

/* TABLA CLIENTE
   Cliente de la empresa y miembro de Tajinaste Plus.

   - ID Cliente (clave primaria)
   - Nombre
   - Apellido
   - Nº de compras al mes
   - Nº de pedidos total
   - Bonificaciones
*/
CREATE TABLE CLIENTE(
   ID_CLIENTE INT NOT NULL,
   NOMBRE VARCHAR(15),
   APELLIDO VARCHAR(15),
   N_COMPRAS INT NOT NULL DEFAULT 0,
   N_PEDIDOS INT NOT NULL DEFAULT 0,
   BONIFICACIONES INT GENERATED ALWAYS AS (N_COMPRAS * 0.1) STORED,
   PRIMARY KEY(ID_CLIENTE)
);

/* TABLA PEDIDOS
   Pedidos realizados en la empresa. Si el cliente no es miembro, tomará valor nulo.

   - ID Pedido (clave primaria)
   - ID cliente (clave ajena),
   - Fecha de pedido
*/
CREATE TABLE PEDIDOS(
   ID_PEDIDO INT NOT NULL,
   ID_CLIENTE INT NULL,
   FECHA DATE NOT NULL,
   PRIMARY KEY (ID_PEDIDO),
   CHECK (FECHA > '12-02-2000')
);

/* TABLA PRODUCTOS
   Productos disponibles en el vivero.ID cliente (clave ajena)
   
   - ID Producto (clave primaria)
   - Precio
   - Peso
*/
CREATE TABLE PRODUCTOS(
   ID_PRODUCTO INT NOT NULL,
   PRECIO FLOAT NOT NULL DEFAULT 0,
   PESO FLOAT NOT NULL DEFAULT 0,
   PRIMARY KEY (ID_PRODUCTO)
);

/* TABLA PRODUCTOS-PEDIDOS
   Relaciona un pedido con los productos comprados en el mismo.

   - ID Pedido (clave primaria)
   - ID Producto (clave primaria y ajena)
   - Cantidad
*/
CREATE TABLE PROD_PED(
   ID_PEDIDO INT NOT NULL,
   ID_PRODUCTO INT NOT NULL,
   CANTIDAD INT NOT NULL DEFAULT 1,
   PRIMARY KEY (ID_PEDIDO, ID_PRODUCTO),
   CONSTRAINT fk_producto
        FOREIGN KEY (ID_PRODUCTO)
            REFERENCES PRODUCTOS(ID_PRODUCTO)
                ON DELETE CASCADE
);

/* TABLA ZONA-PRODUCTOS
   Productos almacenados en una zona determinada de un vivero determinado.

   - ID Zona (clave ajena y primaria)
   - ID Producto (clave ajena y primaria)
   - Stock
*/
CREATE TABLE ZONA_PROD(
    ID_ZONA INT NOT NULL,
    ID_VIVERO INT NOT NULL,
    ID_PRODUCTO INT NOT NULL,
    STOCK INT,
    PRIMARY KEY (ID_ZONA, ID_VIVERO, ID_PRODUCTO),
    CONSTRAINT fk_zona
        FOREIGN KEY(ID_ZONA, ID_VIVERO)
            REFERENCES ZONA(ID_ZONA, ID_VIVERO)
                ON DELETE CASCADE,
    CONSTRAINT fk_producto
        FOREIGN KEY(ID_PRODUCTO)
            REFERENCES PRODUCTOS(ID_PRODUCTO)
                ON DELETE CASCADE
);