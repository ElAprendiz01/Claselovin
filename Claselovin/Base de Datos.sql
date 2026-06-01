CREATE DATABASE Presupuesto_Empresarial;
GO
USE Presupuesto_Empresarial;
GO

-- 1. MAESTROS Y CATÁLOGOS
CREATE TABLE Cat_Estado (
    Id_Estado INT PRIMARY KEY IDENTITY(1,1),
    Estado NVARCHAR(30) NOT NULL,
    Fecha_Creacion DATETIME DEFAULT GETDATE(),
    Fecha_Modificacion DATETIME,
    Id_Creador INT NULL, -- Permitir NULL inicial para evitar el problema del huevo y la gallina
    Id_Modificador INT,
    Activo BIT DEFAULT 1 NOT NULL
);
GO

CREATE TABLE Cat_Tipo_Catalogo (
    Id_Tipo_Catalogo INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(50) NOT NULL,
    Fecha_Creacion DATETIME DEFAULT GETDATE(),
    Fecha_Modificacion DATETIME,
    Id_Creador INT NULL,
    Id_Modificador INT,
    Activo BIT DEFAULT 1 NOT NULL
);
GO

CREATE TABLE Cat_General (
    Id_Catalogo INT PRIMARY KEY IDENTITY(1,1),
    Id_Tipo_Catalogo INT REFERENCES Cat_Tipo_Catalogo(Id_Tipo_Catalogo),
    Nombre NVARCHAR(80) NOT NULL,
    Fecha_Creacion DATETIME DEFAULT GETDATE(),
    Fecha_Modificacion DATETIME,
    Id_Creador INT NULL,
    Id_Modificador INT,
    Activo BIT DEFAULT 1 NOT NULL
);
GO

-- 2. ENTIDADES DE PERSONAL Y SEGURIDAD
CREATE TABLE Tbl_Datos_Personales (
    Id_Persona INT PRIMARY KEY IDENTITY(1,1),
    Id_Genero INT REFERENCES Cat_General(Id_Catalogo),
    Primer_Nombre NVARCHAR(50) NOT NULL,
    Segundo_Nombre NVARCHAR(50),
    Primer_Apellido NVARCHAR(50) NOT NULL,
    Segundo_Apellido NVARCHAR(50),
    Fecha_Nacimiento DATE,
    Id_Tipo_DNI INT REFERENCES Cat_General(Id_Catalogo),
    DNI VARCHAR(20) NOT NULL UNIQUE,
    Fecha_Creacion DATETIME DEFAULT GETDATE(),
    Fecha_Modificacion DATETIME,
    Id_Creador INT NULL, 
    Id_Modificador INT,
    Id_Estado INT REFERENCES Cat_Estado(Id_Estado)
);
GO

CREATE TABLE Tbl_Contacto (
    Id_Contacto INT PRIMARY KEY IDENTITY(1,1),
    Id_Persona INT REFERENCES Tbl_Datos_Personales(Id_Persona),
    Id_Tipo_Contacto INT REFERENCES Cat_General(Id_Catalogo), 
    Contacto NVARCHAR(100) NOT NULL,
    Fecha_Creacion DATETIME DEFAULT GETDATE(),
    Fecha_Modificacion DATETIME,
    Id_Creador INT NULL,
    Id_Modificador INT,
    Id_Estado INT REFERENCES Cat_Estado(Id_Estado)
);
GO

CREATE TABLE Tbl_Roles (
    Id_Rol INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(50) NOT NULL UNIQUE,
    Descripcion NVARCHAR(150),
    Fecha_Creacion DATETIME DEFAULT GETDATE(),
    Fecha_Modificacion DATETIME,
    Id_Creador INT NULL,
    Id_Modificador INT,
    Id_Estado INT REFERENCES Cat_Estado(Id_Estado)
);
GO

CREATE TABLE Tbl_Usuarios (
    Id_Usuario INT PRIMARY KEY IDENTITY(1,1),
    Usuario NVARCHAR(50) NOT NULL UNIQUE,
    Contrasena NVARCHAR(255) NOT NULL, -- Soporta Hashes fuertes como bcrypt/Rfc2898
    Id_Persona INT REFERENCES Tbl_Datos_Personales(Id_Persona),
    Id_Rol INT REFERENCES Tbl_Roles(Id_Rol),
    Fecha_Creacion DATETIME DEFAULT GETDATE(),
    Fecha_Modificacion DATETIME,
    Id_Creador INT NULL,
    Id_Modificador INT,
    Id_Estado INT REFERENCES Cat_Estado(Id_Estado)
);
GO

-- Añadir FKs de auditoría post-creación para garantizar integridad total en el futuro
ALTER TABLE Tbl_Datos_Personales ADD CONSTRAINT FK_Persona_Creador FOREIGN KEY (Id_Creador) REFERENCES Tbl_Usuarios(Id_Usuario);
ALTER TABLE Tbl_Usuarios ADD CONSTRAINT FK_Usuario_Creador FOREIGN KEY (Id_Creador) REFERENCES Tbl_Usuarios(Id_Usuario);
GO

CREATE TABLE Tbl_Permisos_Opciones (
    Id_Permiso INT PRIMARY KEY IDENTITY(1,1),
    Id_Rol INT REFERENCES Tbl_Roles(Id_Rol),
    Modulo NVARCHAR(50) NOT NULL, 
    Puede_Crear BIT DEFAULT 0 NOT NULL,
    Puede_Leer BIT DEFAULT 1 NOT NULL,
    Puede_Actualizar BIT DEFAULT 0 NOT NULL,
    Puede_Eliminar BIT DEFAULT 0 NOT NULL,
    Fecha_Creacion DATETIME DEFAULT GETDATE(),
    Id_Creador INT REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL
);
GO

-- 3. ESTRUCTURA ORGANIZACIONAL Y PRESUPUESTOS
CREATE TABLE Tbl_Departamentos (
    Id_Departamento INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Departamento NVARCHAR(100) NOT NULL UNIQUE,
    Codigo_Softland NVARCHAR(20),
    Fecha_Creacion DATETIME DEFAULT GETDATE(),
    Fecha_Modificacion DATETIME,
    Id_Creador INT REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL,
    Id_Modificador INT,
    Id_Estado INT REFERENCES Cat_Estado(Id_Estado)
);
GO

CREATE TABLE Tbl_Centros_Costo (
    Id_Centro_Costo INT PRIMARY KEY IDENTITY(1,1),
    Id_Departamento INT REFERENCES Tbl_Departamentos(Id_Departamento),
    Nombre_Centro NVARCHAR(100) NOT NULL,
    Codigo_Contable NVARCHAR(50) NOT NULL UNIQUE,
    Fecha_Creacion DATETIME DEFAULT GETDATE(),
    Fecha_Modificacion DATETIME,
    Id_Creador INT REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL,
    Id_Modificador INT,
    Id_Estado INT REFERENCES Cat_Estado(Id_Estado)
);
GO

CREATE TABLE Tbl_Presupuestos (
    Id_Presupuesto INT PRIMARY KEY IDENTITY(1,1),
    Anio_Fiscal INT NOT NULL CONSTRAINT CK_Anio_Fiscal CHECK (Anio_Fiscal >= 2020),
    Descripcion NVARCHAR(150),
    Monto_Total_Asignado DECIMAL(18,2) NOT NULL DEFAULT 0.00 CONSTRAINT CK_Monto_Total CHECK (Monto_Total_Asignado >= 0),
    Fecha_Creacion DATETIME DEFAULT GETDATE(),
    Fecha_Modificacion DATETIME,
    Id_Creador INT REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL,
    Id_Modificador INT,
    Id_Estado INT REFERENCES Cat_Estado(Id_Estado)
);
GO

CREATE TABLE Tbl_Detalle_Presupuesto (
    Id_Presupuesto_Detalle INT PRIMARY KEY IDENTITY(1,1),
    Id_Presupuesto INT REFERENCES Tbl_Presupuestos(Id_Presupuesto),
    Id_Centro_Costo INT REFERENCES Tbl_Centros_Costo(Id_Centro_Costo),
    Id_Categoria_Gasto INT REFERENCES Cat_General(Id_Catalogo), 
    Monto_Presupuestado DECIMAL(18,2) NOT NULL CONSTRAINT CK_Monto_Presupuesto CHECK (Monto_Presupuestado > 0),
    Monto_Ejecutado DECIMAL(18,2) NOT NULL DEFAULT 0.00 CONSTRAINT CK_Monto_Ejecutado CHECK (Monto_Ejecutado >= 0),
    Fecha_Creacion DATETIME DEFAULT GETDATE(),
    Fecha_Modificacion DATETIME,
    Id_Creador INT REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL,
    Id_Modificador INT,
    CONSTRAINT UC_Presupuesto_Detalle UNIQUE (Id_Presupuesto, Id_Centro_Costo, Id_Categoria_Gasto),
    CONSTRAINT CK_Ejecutado_Limite CHECK (Monto_Ejecutado <= Monto_Presupuestado) -- Control de negocio a nivel de BD
);
GO

-- 4. OPERACIONES Y LOGÍSTICA DE CONTROL
CREATE TABLE Tbl_Gastos (
    Id_Gasto INT PRIMARY KEY IDENTITY(1,1),
    Id_Presupuesto_Detalle INT REFERENCES Tbl_Detalle_Presupuesto(Id_Presupuesto_Detalle),
    Descripcion_Gasto NVARCHAR(255) NOT NULL,
    Monto_Gasto DECIMAL(18,2) NOT NULL CONSTRAINT CK_Monto_Gasto CHECK (Monto_Gasto > 0),
    Fecha_Gasto DATETIME NOT NULL DEFAULT GETDATE(),
    Numero_Factura NVARCHAR(50),
    Id_Proveedor INT REFERENCES Cat_General(Id_Catalogo), 
    Fecha_Creacion DATETIME DEFAULT GETDATE(),
    Id_Creador INT REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL, 
    Id_Estado INT REFERENCES Cat_Estado(Id_Estado) 
);
GO

-- Solución al polimorfismo: Claves foráneas explícitas y controladas por un CHECK
CREATE TABLE Tbl_Aprobaciones (
    Id_Aprobacion INT PRIMARY KEY IDENTITY(1,1),
    Id_Presupuesto INT REFERENCES Tbl_Presupuestos(Id_Presupuesto) NULL,
    Id_Gasto INT REFERENCES Tbl_Gastos(Id_Gasto) NULL,
    Id_Usuario_Aprobador INT REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL,
    Fecha_Decision DATETIME DEFAULT GETDATE(),
    Id_Resultado_Aprobacion INT REFERENCES Cat_General(Id_Catalogo) NOT NULL, 
    Comentarios NVARCHAR(255),
    Fecha_Creacion DATETIME DEFAULT GETDATE(),
    Id_Creador INT REFERENCES Tbl_Usuarios(Id_Usuario) NOT NULL,
    CONSTRAINT CK_Entidad_Aprobacion CHECK (
        (Id_Presupuesto IS NOT NULL AND Id_Gasto IS NULL) OR 
        (Id_Gasto IS NOT NULL AND Id_Presupuesto IS NULL)
    ) -- Garantiza que la aprobación pertenezca a un presupuesto O a un gasto, pero nunca a ambos ni a ninguno.
);
GO

CREATE TABLE Tbl_Alertas (
    Id_Alerta INT PRIMARY KEY IDENTITY(1,1),
    Id_Presupuesto_Detalle INT REFERENCES Tbl_Detalle_Presupuesto(Id_Presupuesto_Detalle),
    Porcentaje_Consumido DECIMAL(18,2) NOT NULL, 
    Mensaje_Alerta NVARCHAR(255) NOT NULL,
    Fecha_Generada DATETIME DEFAULT GETDATE(),
    Leida BIT DEFAULT 0 NOT NULL,
    Id_Estado INT REFERENCES Cat_Estado(Id_Estado)
);
GO


-- el tema es sistema de presupuesto empresarial, es decir, una empresa tiene varios departamentos, cada departamento tiene centros de costo, y cada centro de costo tiene un presupuesto asignado para un año fiscal. Luego, a medida que se registran gastos, el sistema debe controlar que no se exceda el monto presupuestado y generar alertas si se acerca al límite. Además, debe haber un proceso de aprobación para los presupuestos y los gastos registrados.

