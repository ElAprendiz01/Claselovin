-- =========================================================================
-- SISTEMA DE CONTROL PRESUPUESTARIO EMPRESARIAL
-- ARQUITECTURA DE BASE DE DATOS OPTIMIZADA - VERSIÓN FINAL BLINDADA
-- =========================================================================

CREATE DATABASE Presupuesto_Empresarial;
GO

USE Presupuesto_Empresarial;
GO

-- =========================================================================
-- 1. MAESTROS, CATÁLOGOS Y MONEDAS (ESTRUCTURAS MADRE)
-- =========================================================================

CREATE TABLE Cat_Estado (
    Id_Estado INT PRIMARY KEY IDENTITY(1,1),
    Estado NVARCHAR(30) NOT NULL,
    Fecha_Creacion DATETIME2(2) DEFAULT SYSDATETIME(),
    Fecha_Modificacion DATETIME2(2),
    Id_Creador INT NULL, 
    Id_Modificador INT,
    Activo BIT DEFAULT 1 NOT NULL
);
GO

CREATE TABLE Cat_Tipo_Catalogo (
    Id_Tipo_Catalogo INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(50) NOT NULL,
    Fecha_Creacion DATETIME2(2) DEFAULT SYSDATETIME(),
    Fecha_Modificacion DATETIME2(2),
    Id_Creador INT NULL,
    Id_Modificador INT,
    Activo BIT DEFAULT 1 NOT NULL
);
GO

CREATE TABLE Cat_General (
    Id_Catalogo INT PRIMARY KEY IDENTITY(1,1),
    Id_Tipo_Catalogo INT CONSTRAINT FK_CatGeneral_TipoCatalogo REFERENCES Cat_Tipo_Catalogo(Id_Tipo_Catalogo),
    Nombre NVARCHAR(80) NOT NULL,
    Fecha_Creacion DATETIME2(2) DEFAULT SYSDATETIME(),
    Fecha_Modificacion DATETIME2(2),
    Id_Creador INT NULL,
    Id_Modificador INT,
    Activo BIT DEFAULT 1 NOT NULL
);
GO

CREATE TABLE Cat_Monedas (
    Id_Moneda INT PRIMARY KEY IDENTITY(1,1),
    Codigo_ISO VARCHAR(3) NOT NULL CONSTRAINT UQ_Moneda_ISO UNIQUE, -- Ej: 'USD', 'NIO', 'EUR'
    Nombre_Moneda NVARCHAR(50) NOT NULL,
    Simbolo VARCHAR(5) NOT NULL,
    Activo BIT DEFAULT 1 NOT NULL
);
GO

-- =========================================================================
-- 2. ENTIDADES DE PERSONAL Y SEGURIDAD
-- =========================================================================

CREATE TABLE Tbl_Datos_Personales (
    Id_Persona INT PRIMARY KEY IDENTITY(1,1),
    Id_Genero INT CONSTRAINT FK_DatosPersonales_Genero REFERENCES Cat_General(Id_Catalogo),
    Primer_Nombre NVARCHAR(50) NOT NULL,
    Segundo_Nombre NVARCHAR(50),
    Primer_Apellido NVARCHAR(50) NOT NULL,
    Segundo_Apellido NVARCHAR(50),
    Fecha_Nacimiento DATE,
    Id_Tipo_DNI INT CONSTRAINT FK_DatosPersonales_TipoDNI REFERENCES Cat_General(Id_Catalogo),
    DNI VARCHAR(20) NOT NULL CONSTRAINT UQ_DatosPersonales_DNI UNIQUE,
    Fecha_Creacion DATETIME2(2) DEFAULT SYSDATETIME(),
    Fecha_Modificacion DATETIME2(2),
    Id_Creador INT NULL, 
    Id_Modificador INT,
    Id_Estado INT CONSTRAINT FK_DatosPersonales_Estado REFERENCES Cat_Estado(Id_Estado)
);
GO

CREATE TABLE Tbl_Contacto (
    Id_Contacto INT PRIMARY KEY IDENTITY(1,1),
    Id_Persona INT CONSTRAINT FK_Contacto_Persona REFERENCES Tbl_Datos_Personales(Id_Persona),
    Id_Tipo_Contacto INT CONSTRAINT FK_Contacto_TipoContacto REFERENCES Cat_General(Id_Catalogo), 
    Contacto NVARCHAR(100) NOT NULL,
    Fecha_Creacion DATETIME2(2) DEFAULT SYSDATETIME(),
    Fecha_Modificacion DATETIME2(2),
    Id_Creador INT NULL,
    Id_Modificador INT,
    Id_Estado INT CONSTRAINT FK_Contacto_Estado REFERENCES Cat_Estado(Id_Estado)
);
GO

CREATE TABLE Tbl_Roles (
    Id_Rol INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(50) NOT NULL CONSTRAINT UQ_Roles_Nombre UNIQUE,
    Descripcion NVARCHAR(150),
    Fecha_Creacion DATETIME2(2) DEFAULT SYSDATETIME(),
    Fecha_Modificacion DATETIME2(2),
    Id_Creador INT NULL,
    Id_Modificador INT,
    Id_Estado INT CONSTRAINT FK_Roles_Estado REFERENCES Cat_Estado(Id_Estado)
);
GO

CREATE TABLE Tbl_Usuarios (
    Id_Usuario INT PRIMARY KEY IDENTITY(1,1),
    Usuario NVARCHAR(50) NOT NULL CONSTRAINT UQ_Usuarios_Login UNIQUE,
    Contrasena NVARCHAR(255) NOT NULL, 
    Id_Persona INT CONSTRAINT FK_Usuarios_Persona REFERENCES Tbl_Datos_Personales(Id_Persona),
    Id_Rol INT CONSTRAINT FK_Usuarios_Rol REFERENCES Tbl_Roles(Id_Rol),
    Fecha_Creacion DATETIME2(2) DEFAULT SYSDATETIME(),
    Fecha_Modificacion DATETIME2(2),
    Id_Creador INT NULL,
    Id_Modificador INT,
    Id_Estado INT CONSTRAINT FK_Usuarios_Estado REFERENCES Cat_Estado(Id_Estado)
);
GO

ALTER TABLE Tbl_Datos_Personales ADD CONSTRAINT FK_Persona_Creador FOREIGN KEY (Id_Creador) REFERENCES Tbl_Usuarios(Id_Usuario);
ALTER TABLE Tbl_Usuarios ADD CONSTRAINT FK_Usuario_Creador FOREIGN KEY (Id_Creador) REFERENCES Tbl_Usuarios(Id_Usuario);
GO

CREATE TABLE Tbl_Permisos_Opciones (
    Id_Permiso INT PRIMARY KEY IDENTITY(1,1),
    Id_Rol INT CONSTRAINT FK_Permisos_Rol REFERENCES Tbl_Roles(Id_Rol),
    Modulo NVARCHAR(50) NOT NULL, 
    Puede_Crear BIT DEFAULT 0 NOT NULL,
    Puede_Leer BIT DEFAULT 1 NOT NULL,
    Puede_Actualizar BIT DEFAULT 0 NOT NULL,
    Puede_Eliminar BIT DEFAULT 0 NOT NULL,
    Fecha_Creacion DATETIME2(2) DEFAULT SYSDATETIME(),
    Id_Creador INT CONSTRAINT FK_Permisos_Creador REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL
);
GO

-- =========================================================================
-- 3. ESTRUCTURA ORGANIZACIONAL Y MODELO PRESUPUESTARIO
-- =========================================================================

CREATE TABLE Tbl_Departamentos (
    Id_Departamento INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Departamento NVARCHAR(100) NOT NULL CONSTRAINT UQ_Departamentos_Nombre UNIQUE,
    Codigo_Softland NVARCHAR(20),
    Fecha_Creacion DATETIME2(2) DEFAULT SYSDATETIME(),
    Fecha_Modificacion DATETIME2(2),
    Id_Creador INT CONSTRAINT FK_Departamentos_Creador REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL,
    Id_Modificador INT,
    Id_Estado INT CONSTRAINT FK_Departamentos_Estado REFERENCES Cat_Estado(Id_Estado)
);
GO

CREATE TABLE Tbl_Centros_Costo (
    Id_Centro_Costo INT PRIMARY KEY IDENTITY(1,1),
    Id_Departamento INT CONSTRAINT FK_CentrosCosto_Departamento REFERENCES Tbl_Departamentos(Id_Departamento),
    Nombre_Centro NVARCHAR(100) NOT NULL,
    Codigo_Contable NVARCHAR(50) NOT NULL CONSTRAINT UQ_CentrosCosto_Codigo UNIQUE,
    Fecha_Creacion DATETIME2(2) DEFAULT SYSDATETIME(),
    Fecha_Modificacion DATETIME2(2),
    Id_Creador INT CONSTRAINT FK_CentrosCosto_Creador REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL,
    Id_Modificador INT,
    Id_Estado INT CONSTRAINT FK_CentrosCosto_Estado REFERENCES Cat_Estado(Id_Estado)
);
GO

CREATE TABLE Tbl_Presupuestos (
    Id_Presupuesto INT PRIMARY KEY IDENTITY(1,1),
    Anio_Fiscal INT NOT NULL CONSTRAINT CK_Anio_Fiscal CHECK (Anio_Fiscal >= 2020),
    Id_Moneda INT CONSTRAINT FK_Presupuestos_Moneda REFERENCES Cat_Monedas(Id_Moneda) DEFAULT 1, 
    Descripcion NVARCHAR(150),
    Fecha_Creacion DATETIME2(2) DEFAULT SYSDATETIME(),
    Fecha_Modificacion DATETIME2(2),
    Id_Creador INT CONSTRAINT FK_Presupuestos_Creador REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL,
    Id_Modificador INT,
    Id_Estado INT CONSTRAINT FK_Presupuestos_Estado REFERENCES Cat_Estado(Id_Estado)
);
GO

CREATE TABLE Tbl_Detalle_Presupuesto (
    Id_Presupuesto_Detalle INT PRIMARY KEY IDENTITY(1,1),
    Id_Presupuesto INT CONSTRAINT FK_Detalle_Presupuesto_Cabecera REFERENCES Tbl_Presupuestos(Id_Presupuesto),
    Id_Centro_Costo INT CONSTRAINT FK_Detalle_CentroCosto REFERENCES Tbl_Centros_Costo(Id_Centro_Costo),
    Id_Categoria_Gasto INT CONSTRAINT FK_Detalle_CategoriaGasto REFERENCES Cat_General(Id_Catalogo), 
    Monto_Presupuestado DECIMAL(18,2) NOT NULL CONSTRAINT CK_Monto_Presupuesto CHECK (Monto_Presupuestado > 0),
    Monto_Ejecutado DECIMAL(18,2) NOT NULL DEFAULT 0.00 CONSTRAINT CK_Monto_Ejecutado CHECK (Monto_Ejecutado >= 0),
    Fecha_Creacion DATETIME2(2) DEFAULT SYSDATETIME(),
    Fecha_Modificacion DATETIME2(2),
    Id_Creador INT CONSTRAINT FK_Detalle_Creador REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL,
    Id_Modificador INT,
    CONSTRAINT UC_Presupuesto_Detalle UNIQUE (Id_Presupuesto, Id_Centro_Costo, Id_Categoria_Gasto),
    CONSTRAINT CK_Ejecutado_Limite CHECK (Monto_Ejecutado <= Monto_Presupuestado)
);
GO

-- NUEVA TABLA: Historial controlado de adendas/ajustes presupuestarios
CREATE TABLE Tbl_Ajustes_Presupuesto (
    Id_Ajuste INT PRIMARY KEY IDENTITY(1,1),
    Id_Presupuesto_Detalle INT CONSTRAINT FK_Ajustes_Detalle REFERENCES Tbl_Detalle_Presupuesto(Id_Presupuesto_Detalle),
    Tipo_Ajuste VARCHAR(15) NOT NULL CONSTRAINT CK_Tipo_Ajuste CHECK (Tipo_Ajuste IN ('INCREMENTO', 'REDUCCION')),
    Monto_Ajuste DECIMAL(18,2) NOT NULL CONSTRAINT CK_Monto_Ajuste CHECK (Monto_Ajuste > 0),
    Justificacion NVARCHAR(255) NOT NULL,
    Fecha_Ajuste DATETIME2(2) DEFAULT SYSDATETIME(),
    Id_Creador INT CONSTRAINT FK_Ajustes_Creador REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL
);
GO

-- =========================================================================
-- 4. OPERACIONES, LOGÍSTICA DE CONTROL Y LOGS
-- =========================================================================

CREATE TABLE Tbl_Gastos (
    Id_Gasto INT PRIMARY KEY IDENTITY(1,1),
    Id_Presupuesto_Detalle INT CONSTRAINT FK_Gastos_DetallePresupuesto REFERENCES Tbl_Detalle_Presupuesto(Id_Presupuesto_Detalle),
    Id_Tipo_Gasto INT CONSTRAINT FK_Gastos_TipoGasto REFERENCES Cat_General(Id_Catalogo), -- Tipo: Caja chica, Reembolso, Factura Directa
    Descripcion_Gasto NVARCHAR(255) NOT NULL,
    Monto_Gasto DECIMAL(18,2) NOT NULL CONSTRAINT CK_Monto_Gasto CHECK (Monto_Gasto > 0),
    Fecha_Gasto DATETIME2(2) NOT NULL DEFAULT SYSDATETIME(),
    Numero_Factura NVARCHAR(50),
    Id_Proveedor INT CONSTRAINT FK_Gastos_Proveedor REFERENCES Cat_General(Id_Catalogo), 
    Fecha_Creacion DATETIME2(2) DEFAULT SYSDATETIME(),
    Id_Creador INT CONSTRAINT FK_Gastos_Creador REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL, 
    Id_Estado INT CONSTRAINT FK_Gastos_Estado REFERENCES Cat_Estado(Id_Estado) 
);
GO

CREATE TABLE Tbl_Aprobaciones (
    Id_Aprobacion INT PRIMARY KEY IDENTITY(1,1),
    Id_Presupuesto INT CONSTRAINT FK_Aprobaciones_Presupuesto REFERENCES Tbl_Presupuestos(Id_Presupuesto) NULL,
    Id_Gasto INT CONSTRAINT FK_Aprobaciones_Gasto REFERENCES Tbl_Gastos(Id_Gasto) NULL,
    Id_Usuario_Aprobador INT CONSTRAINT FK_Aprobaciones_UsuarioAprobador REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL,
    Fecha_Decision DATETIME2(2) DEFAULT SYSDATETIME(),
    Id_Resultado_Aprobacion INT CONSTRAINT FK_Aprobaciones_Resultado REFERENCES Cat_General(Id_Catalogo) NOT NULL, 
    Comentarios NVARCHAR(255),
    Fecha_Creacion DATETIME2(2) DEFAULT SYSDATETIME(),
    Id_Creador INT CONSTRAINT FK_Aprobaciones_Creador REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL,
    CONSTRAINT CK_Entidad_Aprobacion CHECK (
        (Id_Presupuesto IS NOT NULL AND Id_Gasto IS NULL) OR 
        (Id_Gasto IS NOT NULL AND Id_Presupuesto IS NULL)
    )
);
GO

CREATE TABLE Tbl_Alertas (
    Id_Alerta INT PRIMARY KEY IDENTITY(1,1),
    Id_Presupuesto_Detalle INT CONSTRAINT FK_Alertas_DetallePresupuesto REFERENCES Tbl_Detalle_Presupuesto(Id_Presupuesto_Detalle),
    Porcentaje_Consumido DECIMAL(5,2) NOT NULL, 
    Mensaje_Alerta NVARCHAR(255) NOT NULL,
    Fecha_Generada DATETIME2(2) DEFAULT SYSDATETIME(),
    Leida BIT DEFAULT 0 NOT NULL,
    Id_Estado INT CONSTRAINT FK_Alertas_Estado REFERENCES Cat_Estado(Id_Estado)
);
GO
