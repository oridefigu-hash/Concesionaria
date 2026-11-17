USE Concesionaria;
GO

-------------------------------------------------------
--Creamos las tablas:

--MARCA

CREATE TABLE Marca (
    id_marca     INT IDENTITY(1,1) NOT NULL,
    nombre       VARCHAR(60)       NOT NULL,
    pais_origen  VARCHAR(60)       NOT NULL,
    CONSTRAINT PK_Marca PRIMARY KEY (id_marca),
    CONSTRAINT UQ_Marca_nombre UNIQUE (nombre)
);
GO

---MODELO

CREATE TABLE Modelo (
    id_modelo         INT IDENTITY(1,1) NOT NULL,
    denominacion      VARCHAR(80)       NOT NULL,
    version           VARCHAR(60)       NOT NULL,
    anio_fabricacion  SMALLINT          NOT NULL,
    precio_lista      DECIMAL(14,2)     NOT NULL,
    activo            BIT               NOT NULL CONSTRAINT DF_Modelo_activo DEFAULT 1,
    id_marca          INT               NOT NULL,
    CONSTRAINT PK_Modelo PRIMARY KEY (id_modelo),
    CONSTRAINT FK_Modelo_Marca FOREIGN KEY (id_marca) REFERENCES Marca(id_marca),
    CONSTRAINT CK_Modelo_anio CHECK (anio_fabricacion BETWEEN 1900 AND 2100),
    CONSTRAINT CK_Modelo_precio CHECK (precio_lista >= 0)
);
GO

-- SUCURSAL

CREATE TABLE Sucursal (
    cod_sucursal  INT          NOT NULL,
    nombre        VARCHAR(60)  NOT NULL,
    direccion     VARCHAR(120) NOT NULL,
    telefono      VARCHAR(20)  NULL,
    correo        VARCHAR(100) NULL,
    CONSTRAINT PK_Sucursal PRIMARY KEY (cod_sucursal)
);
GO

 
-- PROVEEDOR
 
CREATE TABLE Proveedor (
    cuit          CHAR(13)     NOT NULL,
    razon_social  VARCHAR(100) NOT NULL,
    domicilio     VARCHAR(120) NULL,
    telefono      VARCHAR(20)  NULL,
    correo        VARCHAR(100) NULL,
    CONSTRAINT PK_Proveedor PRIMARY KEY (cuit)
);
GO
 
-- ADQUISICION  

CREATE TABLE Adquisicion (
    id_adquisicion    INT IDENTITY(1,1) NOT NULL,
    nro_comprobante   VARCHAR(30)       NOT NULL,
    tipo_comprobante  VARCHAR(30)       NOT NULL,
    fecha             DATE              NOT NULL,
    importe_total     DECIMAL(14,2)     NOT NULL,
    cuit_proveedor    CHAR(13)          NOT NULL,
    CONSTRAINT PK_Adquisicion PRIMARY KEY (id_adquisicion),
    CONSTRAINT UQ_Adquisicion_comprobante UNIQUE (cuit_proveedor, tipo_comprobante, nro_comprobante),
    CONSTRAINT FK_Adquisicion_Proveedor FOREIGN KEY (cuit_proveedor) REFERENCES Proveedor(cuit),
    CONSTRAINT CK_Adquisicion_importe CHECK (importe_total >= 0)
);
GO

 
-- UNIDAD
-- id_adquisicion es NULL para las unidades recibidas como parte de pago.
-- ---------------------------------------------------------------------
CREATE TABLE Unidad (
    nro_serie_vin   VARCHAR(17)   NOT NULL,
    nro_motor       VARCHAR(30)   NOT NULL,
    color           VARCHAR(30)   NOT NULL,
    fecha_ingreso   DATE          NOT NULL,
    condicion       VARCHAR(10)   NOT NULL,
    precio_venta    DECIMAL(14,2) NOT NULL,
    estado          VARCHAR(20)   NOT NULL CONSTRAINT DF_Unidad_estado DEFAULT 'Disponible',
    id_modelo       INT           NOT NULL,
    cod_sucursal    INT           NOT NULL,
    id_adquisicion  INT           NULL,
    CONSTRAINT PK_Unidad PRIMARY KEY (nro_serie_vin),
    CONSTRAINT UQ_Unidad_nro_motor UNIQUE (nro_motor),
    CONSTRAINT FK_Unidad_Modelo FOREIGN KEY (id_modelo) REFERENCES Modelo(id_modelo),
    CONSTRAINT FK_Unidad_Sucursal FOREIGN KEY (cod_sucursal) REFERENCES Sucursal(cod_sucursal),
    CONSTRAINT FK_Unidad_Adquisicion FOREIGN KEY (id_adquisicion) REFERENCES Adquisicion(id_adquisicion),
    CONSTRAINT CK_Unidad_condicion CHECK (condicion IN ('Nueva', 'Usada')),
    CONSTRAINT CK_Unidad_estado CHECK (estado IN ('Disponible', 'Reservada', 'Vendida', 'Fuera de exhibicion')),
    CONSTRAINT CK_Unidad_precio CHECK (precio_venta >= 0)
);
GO

-- CLIENTE 

CREATE TABLE Cliente (
    tipo_doc   VARCHAR(10)  NOT NULL,
    nro_doc    VARCHAR(15)  NOT NULL,
    nombre     VARCHAR(60)  NOT NULL,
    apellido   VARCHAR(60)  NOT NULL,
    domicilio  VARCHAR(120) NULL,
    correo     VARCHAR(100) NULL,
    CONSTRAINT PK_Cliente PRIMARY KEY (tipo_doc, nro_doc)
);
GO


-- CONTACTO

CREATE TABLE Contacto (
    tipo_doc      VARCHAR(10) NOT NULL,
    nro_doc       VARCHAR(15) NOT NULL,
    nro_telefono  VARCHAR(20) NOT NULL,
    nombre        VARCHAR(100) NOT NULL,  -- persona a la que pertenece el telefono
    CONSTRAINT PK_Contacto PRIMARY KEY (tipo_doc, nro_doc, nro_telefono),
    CONSTRAINT FK_Contacto_Cliente FOREIGN KEY (tipo_doc, nro_doc)
        REFERENCES Cliente(tipo_doc, nro_doc) ON DELETE CASCADE
);
GO

-- EMPLEADO 

CREATE TABLE Empleado (
    legajo         INT          NOT NULL,
    nombre         VARCHAR(60)  NOT NULL,
    apellido       VARCHAR(60)  NOT NULL,
    fecha_ingreso  DATE         NOT NULL,
    telefono       VARCHAR(20)  NULL,
    correo         VARCHAR(100) NULL,
    cod_sucursal   INT          NOT NULL,
    CONSTRAINT PK_Empleado PRIMARY KEY (legajo),
    CONSTRAINT FK_Empleado_Sucursal FOREIGN KEY (cod_sucursal) REFERENCES Sucursal(cod_sucursal)
);
GO

-- ESPECIALIZACION de Empleado: VENDEDOR y ADMINISTRATIVO

CREATE TABLE Vendedor (
    legajo INT NOT NULL,
    CONSTRAINT PK_Vendedor PRIMARY KEY (legajo),
    CONSTRAINT FK_Vendedor_Empleado FOREIGN KEY (legajo) REFERENCES Empleado(legajo)
);
GO

CREATE TABLE Administrativo (
    legajo INT NOT NULL,
    CONSTRAINT PK_Administrativo PRIMARY KEY (legajo),
    CONSTRAINT FK_Administrativo_Empleado FOREIGN KEY (legajo) REFERENCES Empleado(legajo)
);
GO


-- PLAN_FINANCIACION

CREATE TABLE Plan_Financiacion (
    cod_plan              INT          NOT NULL,
    descripcion           VARCHAR(100) NOT NULL,
    porc_max_financiable  DECIMAL(5,2) NOT NULL,
    cant_max_cuotas       SMALLINT     NOT NULL,
    tasa_interes_anual    DECIMAL(5,2) NOT NULL,
    CONSTRAINT PK_Plan_Financiacion PRIMARY KEY (cod_plan),
    CONSTRAINT CK_Plan_porcentaje CHECK (porc_max_financiable BETWEEN 0 AND 100),
    CONSTRAINT CK_Plan_cuotas CHECK (cant_max_cuotas > 0),
    CONSTRAINT CK_Plan_tasa CHECK (tasa_interes_anual >= 0)
);
GO

-- ---------------------------------------------------------------------
-- BOLETO
--  * corresponde: Cliente 1-N Boleto
--  * gestiona:    Vendedor 1-N Boleto
--  * registra:    Boleto N-1 Unidad (vehiculo que se compra)
--  * utiliza:     Boleto N-1 Plan_Financiacion (opcional)
--  * entrega_como_pago: relacion 1:1 opcional entre Boleto y Unidad.
--    Se resuelve con dos columnas en Boleto (NULL si no hay entrega):
--    nro_serie_vin_entregada y valor_reconocido (atributo de la relacion).
-- ---------------------------------------------------------------------
CREATE TABLE Boleto (
    nro_boleto        INT           NOT NULL,
    fecha_emision     DATE          NOT NULL,
    importe_total     DECIMAL(14,2) NOT NULL,
    estado            VARCHAR(20)   NOT NULL CONSTRAINT DF_Boleto_estado DEFAULT 'En negociacion',
    tipo_doc_cliente  VARCHAR(10)   NOT NULL,
    nro_doc_cliente   VARCHAR(15)   NOT NULL,
    legajo_vendedor   INT           NOT NULL,
    nro_serie_vin     VARCHAR(17)   NOT NULL,
    cod_plan          INT           NULL,
    nro_serie_vin_entregada    VARCHAR(17)   NULL,
    valor_reconocido  DECIMAL(14,2) NULL,
    CONSTRAINT PK_Boleto PRIMARY KEY (nro_boleto),
    CONSTRAINT FK_Boleto_Cliente FOREIGN KEY (tipo_doc_cliente, nro_doc_cliente) REFERENCES Cliente(tipo_doc, nro_doc),
    CONSTRAINT FK_Boleto_Vendedor FOREIGN KEY (legajo_vendedor) REFERENCES Vendedor(legajo),
    CONSTRAINT FK_Boleto_Unidad FOREIGN KEY (nro_serie_vin) REFERENCES Unidad(nro_serie_vin),
    CONSTRAINT FK_Boleto_Plan FOREIGN KEY (cod_plan) REFERENCES Plan_Financiacion(cod_plan),
    CONSTRAINT FK_Boleto_ParteDePago FOREIGN KEY (nro_serie_vin_entregada) REFERENCES Unidad(nro_serie_vin),
    CONSTRAINT CK_Boleto_estado CHECK (estado IN ('En negociacion', 'Confirmado', 'Cancelado')),
    CONSTRAINT CK_Boleto_importe CHECK (importe_total >= 0),

    -- La entrega y su valor van juntos: o estan los dos o ninguno
    CONSTRAINT CK_Boleto_parte_pago CHECK (
        (nro_serie_vin_entregada IS NULL AND valor_reconocido IS NULL)
        OR (nro_serie_vin_entregada IS NOT NULL AND valor_reconocido IS NOT NULL)
    ),
    -- No se puede entregar como parte de pago el mismo auto que se compra
    CONSTRAINT CK_Boleto_vin_distintos CHECK (nro_serie_vin_entregada IS NULL OR nro_serie_vin_entregada <> nro_serie_vin)
);
GO

-- Una unidad solo puede haber sido entregada como parte de pago en un boleto
-- (cardinalidad 0,1 del MER). Indice unico filtrado: ignora los NULL.
CREATE UNIQUE INDEX UX_Boleto_nro_serie_vin_entregada
    ON Boleto (nro_serie_vin_entregada)
    WHERE nro_serie_vin_entregada IS NOT NULL;
GO


-- PAGO_PROGRAMADO  (entidad debil de Boleto)
-- Clave: nro_boleto + nro_cuota (clave parcial).

CREATE TABLE Pago_Programado (
    nro_boleto         INT           NOT NULL,
    nro_cuota          SMALLINT      NOT NULL,
    fecha_vencimiento  DATE          NOT NULL,
    importe            DECIMAL(14,2) NOT NULL,
    estado             VARCHAR(20)   NOT NULL CONSTRAINT DF_Pago_estado DEFAULT 'Pendiente',
    CONSTRAINT PK_Pago_Programado PRIMARY KEY (nro_boleto, nro_cuota),
    CONSTRAINT FK_Pago_Boleto FOREIGN KEY (nro_boleto) REFERENCES Boleto(nro_boleto) ON DELETE CASCADE,
    CONSTRAINT CK_Pago_cuota CHECK (nro_cuota > 0),
    CONSTRAINT CK_Pago_importe CHECK (importe > 0),
    -- El enunciado no define los estados de un pago: estos valores son un supuesto
    CONSTRAINT CK_Pago_estado CHECK (estado IN ('Pendiente', 'Pagado', 'Vencido'))
);
GO


-- ACCESORIO

CREATE TABLE Accesorio (
    cod_accesorio  INT          NOT NULL,
    descripcion    VARCHAR(100) NOT NULL,
    precio         DECIMAL(12,2) NOT NULL,
    disponible     BIT          NOT NULL CONSTRAINT DF_Accesorio_disponible DEFAULT 1,
    CONSTRAINT PK_Accesorio PRIMARY KEY (cod_accesorio),
    CONSTRAINT CK_Accesorio_precio CHECK (precio >= 0)
);
GO


-- BOLETO_ACCESORIO  (relacion "incluye", N:M entre Boleto y Accesorio)
-- precio_unitario y cantidad son atributos de la relacion

CREATE TABLE Boleto_Accesorio (
    nro_boleto       INT           NOT NULL,
    cod_accesorio    INT           NOT NULL,
    cantidad         SMALLINT      NOT NULL CONSTRAINT DF_BoletoAcc_cantidad DEFAULT 1,
    precio_unitario  DECIMAL(12,2) NOT NULL,
    CONSTRAINT PK_Boleto_Accesorio PRIMARY KEY (nro_boleto, cod_accesorio),
    CONSTRAINT FK_BoletoAcc_Boleto FOREIGN KEY (nro_boleto) REFERENCES Boleto(nro_boleto) ON DELETE CASCADE,
    CONSTRAINT FK_BoletoAcc_Accesorio FOREIGN KEY (cod_accesorio) REFERENCES Accesorio(cod_accesorio),
    CONSTRAINT CK_BoletoAcc_cantidad CHECK (cantidad > 0),
    CONSTRAINT CK_BoletoAcc_precio CHECK (precio_unitario >= 0)
);
GO

-- Para comprobar que se crearon las 16 tablas:
 SELECT name FROM sys.tables ORDER BY name;
