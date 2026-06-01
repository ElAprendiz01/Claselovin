USE Presupuesto_Empresarial;
GO


-- REINICIAR ENTORNO TRANSACCIONAL (Para garantizar idoneidad en la ejecución limpia)
DELETE FROM Tbl_Alertas;
DELETE FROM Tbl_Aprobaciones;
DELETE FROM Tbl_Gastos;
DELETE FROM Tbl_Detalle_Presupuesto;
DELETE FROM Tbl_Presupuestos;
DELETE FROM Tbl_Centros_Costo;
DELETE FROM Tbl_Departamentos;
DELETE FROM Tbl_Permisos_Opciones;
DELETE FROM Tbl_Usuarios;
DELETE FROM Tbl_Contacto;
DELETE FROM Tbl_Datos_Personales;
DELETE FROM Cat_General;
DELETE FROM Cat_Tipo_Catalogo;
DELETE FROM Cat_Estado;
GO

-- =========================================================================
-- STEP 1: CATALOGOS PRIMARIOS (Auditoría NULL para romper ciclo de arranque)
-- =========================================================================



INSERT INTO Cat_Estado (Estado, Id_Creador, Activo) VALUES 
('Activo', NULL, 1),               -- ID: 1
('Inactivo', NULL, 1),             -- ID: 2
('Pendiente Aprobación', NULL, 1), -- ID: 3
('Aprobado', NULL, 1),             -- ID: 4
('Rechazado', NULL, 1),            -- ID: 5
('Borrador', NULL, 1);             -- ID: 6
GO

INSERT INTO Cat_Tipo_Catalogo (Nombre, Id_Creador, Activo) VALUES 
('Género', NULL, 1),               -- ID: 1
('Tipo DNI', NULL, 1),             -- ID: 2
('Tipo Contacto', NULL, 1),        -- ID: 3
('Categoría de Gasto', NULL, 1),   -- ID: 4
('Resultado Aprobación', NULL, 1), -- ID: 5
('Proveedores', NULL, 1);          -- ID: 6
GO

INSERT INTO Cat_General (Id_Tipo_Catalogo, Nombre, Id_Creador, Activo) VALUES 
(1, 'Masculino', NULL, 1),              -- ID: 1
(1, 'Femenino', NULL, 1),               -- ID: 2
(2, 'Cédula de Identidad', NULL, 1),    -- ID: 3
(2, 'Pasaporte', NULL, 1),              -- ID: 4
(3, 'Correo Electrónico', NULL, 1),     -- ID: 5
(3, 'Teléfono Móvil', NULL, 1),         -- ID: 6
(4, 'Tecnología y Software', NULL, 1),  -- ID: 7
(4, 'Marketing y Publicidad', NULL, 1), -- ID: 8
(4, 'Recursos Humanos', NULL, 1),       -- ID: 9
(4, 'Operaciones y Logística', NULL, 1),-- ID: 10
(5, 'Autorizado', NULL, 1),             -- ID: 11
(5, 'Rechazado', NULL, 1),              -- ID: 12
(6, 'Amazon Web Services', NULL, 1),    -- ID: 13
(6, 'Agencia Creativa S.A.', NULL, 1),  -- ID: 14
(6, 'Consultores de Talento Global', NULL, 1); -- ID: 15 (Nuevo para RRHH)
GO


-- =========================================================================
-- STEP 2: ENTIDADES DE PERSONAL, SEGURIDAD Y PERMISOS
-- =========================================================================

INSERT INTO Tbl_Roles (Nombre, Descripcion, Id_Creador, Id_Estado) VALUES 
('Administrador', 'Acceso total al sistema y configuraciones', NULL, 1),         -- ID: 1
('Gerente Financiero', 'Aprobación de presupuestos y reportes macro', NULL, 1),   -- ID: 2
('Analista de Presupuestos', 'Carga de gastos y revisión de desviaciones', NULL, 1); -- ID: 3
GO

INSERT INTO Tbl_Datos_Personales (Id_Genero, Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, Fecha_Nacimiento, Id_Tipo_DNI, DNI, Id_Creador, Id_Estado) VALUES 
(1, 'Carlos', 'Alberto', 'Mendoza', 'Ruiz', '1985-04-12', 3, '001-120485-0001A', NULL, 1), -- ID: 1
(2, 'Ana', 'Beatriz', 'Gómez', 'López', '1990-08-22', 3, '001-220890-0002B', NULL, 1),   -- ID: 2
(1, 'Juan', 'Carlos', 'Pérez', 'Castro', '1995-11-05', 3, '001-051195-0003C', NULL, 1);  -- ID: 3
GO

INSERT INTO Tbl_Contacto (Id_Persona, Id_Tipo_Contacto, Contacto, Id_Creador, Id_Estado) VALUES 
(1, 5, 'carlos.mendoza@empresa.com', NULL, 1),
(1, 6, '+505 8888-1111', NULL, 1),
(2, 5, 'ana.gomez@empresa.com', NULL, 1),
(3, 5, 'juan.perez@empresa.com', NULL, 1);
GO

INSERT INTO Tbl_Usuarios (Usuario, Contrasena, Id_Persona, Id_Rol, Id_Creador, Id_Estado) VALUES 
('admin_sys', 'Hash_Secure_Admin_2026', 1, 1, NULL, 1),     -- ID: 1
('ana_finanzas', 'Hash_Secure_Gerente_2026', 2, 2, 1, 1), -- ID: 2
('juan_analista', 'Hash_Secure_Analista_2026', 3, 3, 1, 1); -- ID: 3
GO

-- REGULARIZACIÓN DE AUDITORÍA (Asignar al Administrador del sistema el track inicial)
UPDATE Cat_Estado SET Id_Creador = 1;
UPDATE Cat_Tipo_Catalogo SET Id_Creador = 1;
UPDATE Cat_General SET Id_Creador = 1;
UPDATE Tbl_Roles SET Id_Creador = 1;
UPDATE Tbl_Datos_Personales SET Id_Creador = 1;
UPDATE Tbl_Contacto SET Id_Creador = 1;
UPDATE Tbl_Usuarios SET Id_Creador = 1 WHERE Id_Usuario = 1;
GO

INSERT INTO Tbl_Permisos_Opciones (Id_Rol, Modulo, Puede_Crear, Puede_Leer, Puede_Actualizar, Puede_Eliminar, Id_Creador) VALUES 
(1, 'Todos', 1, 1, 1, 1, 1),
(2, 'Presupuestos', 1, 1, 1, 0, 1),
(2, 'Aprobaciones', 1, 1, 1, 0, 1),
(3, 'Gastos', 1, 1, 0, 0, 1);
GO


-- =========================================================================
-- STEP 3: ESTRUCTURA ORGANIZACIONAL Y PLANIFICACIÓN DE FONDOS
-- =========================================================================

INSERT INTO Tbl_Departamentos (Nombre_Departamento, Codigo_Softland, Id_Creador, Id_Estado) VALUES 
('Tecnologías de la Informática', 'DEP-TI', 1, 1), -- ID: 1
('Marketing y Ventas', 'DEP-MKT', 1, 1),            -- ID: 2
('Recursos Humanos', 'DEP-RRHH', 1, 1);              -- ID: 3
GO

INSERT INTO Tbl_Centros_Costo (Id_Departamento, Nombre_Centro, Codigo_Contable, Id_Creador, Id_Estado) VALUES 
(1, 'Infraestructura y Cloud', 'CC-TI-01', 1, 1),   -- ID: 1
(1, 'Desarrollo de Software', 'CC-TI-02', 1, 1),    -- ID: 2
(2, 'Publicidad Digital', 'CC-MKT-01', 1, 1),        -- ID: 3
(3, 'Capacitación y Desarrollo', 'CC-RRHH-01', 1, 1);-- ID: 4
GO

INSERT INTO Tbl_Presupuestos (Anio_Fiscal, Descripcion, Id_Creador, Id_Estado) VALUES 
(2026, 'Presupuesto General Corporativo Año 2026', 1, 4); -- ID: 1 (Estado: Aprobado)
GO

INSERT INTO Tbl_Detalle_Presupuesto (Id_Presupuesto, Id_Centro_Costo, Id_Categoria_Gasto, Monto_Presupuestado, Monto_Ejecutado, Id_Creador) VALUES 
(1, 1, 7, 40000.00, 0.00, 1),  -- ID Detalle: 1 (CC: Infraestructura | Cat: Tecnología) -> Techo: $40,000.00
(1, 3, 8, 25000.00, 0.00, 1),  -- ID Detalle: 2 (CC: Publicidad Digital | Cat: Marketing) -> Techo: $25,000.00
(1, 4, 9, 10000.00, 0.00, 1);  -- ID Detalle: 3 (CC: Capacitación | Cat: RRHH)       -> Techo: $10,000.00
GO


-- =========================================================================
-- STEP 4: OPERACIÓN (Inserción de Gastos y Ejecución Automática por Trigger)
-- =========================================================================

-- Al insertar aquí, el TRIGGER 'TR_TblGastos_Control_Presupuesto' actualizará Monto_Ejecutado automáticamente.
INSERT INTO Tbl_Gastos (Id_Presupuesto_Detalle, Descripcion_Gasto, Monto_Gasto, Fecha_Gasto, Numero_Factura, Id_Proveedor, Id_Creador, Id_Estado) VALUES 
(1, 'Pago Mensual Servidores AWS May-2026', 12500.00, '2026-05-25', 'FACT-AWS-992', 13, 3, 4), -- Detalle 1: Consumo acumula $12,500.00
(1, 'Renovación de Licencias IDEs de Desarrollo', 5000.00, '2026-05-28', 'FACT-JB-102', 13, 3, 4);  -- Detalle 1: Consumo acumula $17,500.00 (43.75%)
GO

-- SIMULACIÓN DE DISPARO DE ALERTA TRANSACCIONAL (Gasto alto automatizado):
-- Al insertar este registro, el trigger calculará un consumo acumulado de $22,000.00 sobre un techo de $25,000.00.
-- Esto representa el 88.00% de ejecución. El trigger escribirá la alerta de forma síncrona.
INSERT INTO Tbl_Gastos (Id_Presupuesto_Detalle, Descripcion_Gasto, Monto_Gasto, Fecha_Gasto, Numero_Factura, Id_Proveedor, Id_Creador, Id_Estado) VALUES 
(2, 'Campaña Social Ads Lanzamiento Q2', 22000.00, '2026-05-29', 'FACT-AC-004', 14, 3, 4);
GO


-- =========================================================================
-- STEP 5: HISTÓRICO DE AUDITORÍA DE APROBACIONES
-- =========================================================================

INSERT INTO Tbl_Aprobaciones (Id_Presupuesto, Id_Gasto, Id_Usuario_Aprobador, Id_Resultado_Aprobacion, Comentarios, Id_Creador) VALUES 
(1, NULL, 2, 11, 'Presupuesto anual autorizado tras revisión de objetivos de la junta técnica.', 2), -- Aprobación a Presupuesto
(NULL, 3, 2, 11, 'Gasto de campaña publicitaria aprobado por urgencia comercial.', 2);        -- Aprobación a Gasto
GO


-- =========================================================================
-- STEP 6: VERIFICACIÓN Y AUDITORÍA DE VOLUMETRÍA
-- =========================================================================

SELECT 'Estados' AS [Tabla], COUNT(*) AS [Registros Total] FROM Cat_Estado
UNION ALL
SELECT 'Tipos de Catálogos', COUNT(*) FROM Cat_Tipo_Catalogo
UNION ALL
SELECT 'Catálogo General', COUNT(*) FROM Cat_General
UNION ALL
SELECT 'Usuarios', COUNT(*) FROM Tbl_Usuarios
UNION ALL
SELECT 'Centros de Costo', COUNT(*) FROM Tbl_Centros_Costo
UNION ALL
SELECT 'Detalles de Presupuesto', COUNT(*) FROM Tbl_Detalle_Presupuesto
UNION ALL
SELECT 'Gastos Transaccionados', COUNT(*) FROM Tbl_Gastos
UNION ALL
SELECT 'Alertas Generadas por el Motor', COUNT(*) FROM Tbl_Alertas;
GO

-- CONSULTA ANALÍTICA: Dashboard de control en tiempo real
SELECT 
    D.Id_Presupuesto_Detalle,
    DEP.Nombre_Departamento AS [Departamento],
    CC.Nombre_Centro AS [Centro Costo],
    CG.Nombre AS [Categoría Gasto],
    D.Monto_Presupuestado AS [Presupuesto Asignado],
    D.Monto_Ejecutado AS [Total Ejecutado Automático],
    (D.Monto_Presupuestado - D.Monto_Ejecutado) AS [Fondo Disponible],
    CAST(((D.Monto_Ejecutado / D.Monto_Presupuestado) * 100.00) AS DECIMAL(5,2)) AS [% Ejecución]
FROM Tbl_Detalle_Presupuesto D
INNER JOIN Tbl_Centros_Costo CC ON D.Id_Centro_Costo = CC.Id_Centro_Costo
INNER JOIN Tbl_Departamentos DEP ON CC.Id_Departamento = DEP.Id_Departamento
INNER JOIN Cat_General CG ON D.Id_Categoria_Gasto = CG.Id_Catalogo;
GO

-- CONSULTA DE ALERTAS EMITIDAS POR EL TRIGGER
SELECT 
    A.Id_Alerta,
    CC.Nombre_Centro AS [Centro de Costo Afectado],
    A.Porcentaje_Consumido AS [% Comprometido],
    A.Mensaje_Alerta AS [Log Notificación Engine],
    A.Fecha_Generada
FROM Tbl_Alertas A
INNER JOIN Tbl_Detalle_Presupuesto DP ON A.Id_Presupuesto_Detalle = DP.Id_Presupuesto_Detalle
INNER JOIN Tbl_Centros_Costo CC ON DP.Id_Centro_Costo = CC.Id_Centro_Costo;
GO