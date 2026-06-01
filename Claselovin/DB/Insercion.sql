USE Presupuesto_Empresarial;
GO


INSERT INTO Cls_Estado (Estado, Id_Creador, Activo) VALUES 
('Activo', 1, 1),               -- ID: 1
('Inactivo', 1, 1),             -- ID: 2
('Pendiente Aprobación', 1, 1), -- ID: 3
('Aprobado', 1, 1),             -- ID: 4
('Rechazado', 1, 1),            -- ID: 5
('Borrador', 1, 1);             -- ID: 6
GO


INSERT INTO Cls_Tipo_Catalogo (Nombre, Id_Creador, Activo) VALUES 
('Género', 1, 1),               -- ID: 1
('Tipo DNI', 1, 1),             -- ID: 2
('Tipo Contacto', 1, 1),        -- ID: 3
('Categoría de Gasto', 1, 1),   -- ID: 4
('Resultado Aprobación', 1, 1), -- ID: 5
('Proveedores', 1, 1);          -- ID: 6
GO


INSERT INTO Cls_Catalogo (Id_Tipo_Catalogo, Nombre, Id_Creador, Activo) VALUES 
(1, 'Masculino', 1, 1),			     -- ID: 1
(1, 'Femenino', 1, 1),			     -- ID: 2
(2, 'Cédula de Identidad', 1, 1),-- ID: 3
(2, 'Pasaporte', 1, 1),			     -- ID: 4
(3, 'Correo Electrónico', 1, 1), -- ID: 5
(3, 'Teléfono Móvil', 1, 1),	   -- ID: 6
(4, 'Tecnología y Software', 1, 1),-- ID: 7
(4, 'Marketing y Publicidad', 1, 1),-- ID: 8
(4, 'Recursos Humanos', 1, 1),	 -- ID: 9
(4, 'Operaciones y Logística', 1, 1),-- ID: 10
(5, 'Aprobado', 1, 1),			     -- ID: 11
(5, 'Rechazado', 1, 1),			     -- ID: 12
(6, 'Amazon Web Services', 1, 1),-- ID: 13
(6, 'Agencia Creativa S.A.', 1, 1);-- ID: 14
GO



INSERT INTO Tbl_Roles (Nombre, Descripcion, Id_Creador, Id_Estado) VALUES 
('Administrador', 'Acceso total al sistema y configuraciones', 1, 1),         -- ID: 1
('Gerente Financiero', 'Aprobación de presupuestos y reportes macro', 1, 1),   -- ID: 2
('Analista de Presupuestos', 'Carga de gastos y revisión de desviaciones', 1, 1); -- ID: 3
GO


INSERT INTO Tbl_Permisos_Opciones (Id_Rol, Modulo, Puede_Crear, Puede_Leer, Puede_Actualizar, Puede_Eliminar, Id_Creador) VALUES 
(1, 'Todos', 1, 1, 1, 1, 1),
(2, 'Presupuestos', 1, 1, 1, 0, 1),
(2, 'Aprobaciones', 1, 1, 1, 0, 1),
(3, 'Gastos', 1, 1, 0, 0, 1);
GO


INSERT INTO Tbl_Datos_Personales (Genero, Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, Fecha_Nacimiento, Tipo_DNI, DNI, Id_Creador, Id_Estado) VALUES 
(1, 'Carlos', 'Alberto', 'Mendoza', 'Ruiz', '1985-04-12', 3, '001-120485-0001A', 1, 1), -- ID: 1
(2, 'Ana', 'Beatriz', 'Gómez', 'López', '1990-08-22', 3, '001-220890-0002B', 1, 1),   -- ID: 2
(1, 'Juan', 'Carlos', 'Pérez', 'Castro', '1995-11-05', 3, '001-051195-0003C', 1, 1);  -- ID: 3
GO

Select * from Tbl_Datos_Personales
-- Tbl_Contacto
INSERT INTO Tbl_Contacto (Id_Persona, Tipo_Contacto, Contacto, Id_Creador, Id_Estado) VALUES 
(1, 5, 'carlos.mendoza@empresa.com', 1, 1),
(1, 6, '+505 8888-1111', 1, 1),
(2, 5, 'ana.gomez@empresa.com', 1, 1),
(3, 5, 'juan.perez@empresa.com', 1, 1);
GO

-- Tbl_Usuarios
INSERT INTO Tbl_Usuarios (Usuario, Contrasena, Id_Persona, Id_Rol, Id_Creador, Id_Estado) VALUES 
('admin_sys', 'Hash_Secure_Admin_2026', 1, 1, 1, 1),     -- ID: 1
('ana_finanzas', 'Hash_Secure_Gerente_2026', 2, 2, 1, 1), -- ID: 2
('juan_analista', 'Hash_Secure_Analista_2026', 3, 3, 1, 1); -- ID: 3
GO



INSERT INTO Tbl_Departamentos (Nombre_Departamento, Codigo_Softland, Id_Creador, Id_Estado) VALUES 
('Tecnologías de la Información', 'DEP-TI', 1, 1), -- ID: 1
('Marketing y Ventas', 'DEP-MKT', 1, 1),            -- ID: 2
('Recursos Humanos', 'DEP-RRHH', 1, 1);              -- ID: 3
GO

-- Tbl_Centros_Costo
INSERT INTO Tbl_Centros_Costo (Id_Departamento, Nombre_Centro, Codigo_Contable, Id_Creador, Id_Estado) VALUES 
(1, 'Infraestructura y Cloud', 'CC-TI-01', 1, 1),   -- ID: 1
(1, 'Desarrollo de Software', 'CC-TI-02', 1, 1),    -- ID: 2
(2, 'Publicidad Digital', 'CC-MKT-01', 1, 1),        -- ID: 3
(3, 'Capacitación y Desarrollo', 'CC-RRHH-01', 1, 1);-- ID: 4
GO



INSERT INTO Tbl_Presupuestos (Anio_Fiscal, Descripcion, Monto_Total_Asignado, Id_Creador, Id_Estado) VALUES 
(2026, 'Presupuesto General Corporativo Año 2026', 75000.00, 1, 4); -- ID: 1 (Estado: Aprobado)
GO


INSERT INTO Tbl_Detalle_Presupuesto (Id_Presupuesto, Id_Centro_Costo, Id_Categoria_Gasto, Monto_Presupuestado, Monto_Ejecutado, Id_Creador) VALUES 
(1, 1, 7, 40000.00, 0.00, 1),  -- ID Detalle: 1 (TI - Tecnología)
(1, 3, 8, 25000.00, 0.00, 1),  -- ID Detalle: 2 (Mkt - Publicidad)
(1, 4, 9, 10000.00, 0.00, 1);  -- ID Detalle: 3 (RRHH - Capacitación)
GO


INSERT INTO Tbl_Gastos (Id_Presupuesto_Detalle, Descripcion_Gasto, Monto_Gasto, Fecha_Gasto, Numero_Factura, Proveedor, Id_Creador, Id_Estado) VALUES 
(1, 'Pago Mensual Servidores AWS May-2026', 12500.00, '2026-05-25', 'FACT-AWS-992', 13, 3, 4), -- Vincula a Detalle 1
(1, 'Renovación de Licencias IDEs de Desarrollo', 5000.00, '2026-05-28', 'FACT-JB-102', 13, 3, 4),  -- Vincula a Detalle 1
(2, 'Campaña Social Ads Lanzamiento Q2', 22000.00, '2026-05-29', 'FACT-AC-004', 14, 3, 4);       -- Vincula a Detalle 2
GO

-- Sincronizar de forma segura los totales ejecutados de las transacciones en los detalles del presupuesto
UPDATE Tbl_Detalle_Presupuesto SET Monto_Ejecutado = 17500.00 WHERE Id_Presupuesto_Detalle = 1; 
UPDATE Tbl_Detalle_Presupuesto SET Monto_Ejecutado = 22000.00 WHERE Id_Presupuesto_Detalle = 2; 
GO



INSERT INTO Tbl_Aprobaciones (Tipo_Entidad, Id_Entidad_Ref, Id_Usuario_Aprobador, Id_Resultado_Aprobacion, Comentarios, Id_Creador) VALUES 
('PRESUPUESTO', 1, 2, 11, 'Presupuesto anual autorizado tras revisión de objetivos de la junta técnica.', 2),
('GASTO', 3, 2, 11, 'Gasto de campaña publicitaria aprobado por urgencia comercial.', 2);
GO

-- Tbl_Alertas
INSERT INTO Tbl_Alertas (Id_Presupuesto_Detalle, Porcentaje_Consumido, Mensaje_Alerta, Leida, Id_Estado) VALUES 
(2, 88.00, 'CRÍTICO: El Centro de Costo (Publicidad Digital) ha ejecutado más del 80% de su presupuesto.', 0, 1);
GO

SELECT 
    (SELECT COUNT(*) FROM Cls_Estado) AS Estados,
    (SELECT COUNT(*) FROM Cls_Catalogo) AS Catalogos,
    (SELECT COUNT(*) FROM Tbl_Usuarios) AS Usuarios,
    (SELECT COUNT(*) FROM Tbl_Centros_Costo) AS Centros_Costo,
    (SELECT COUNT(*) FROM Tbl_Detalle_Presupuesto) AS Detalles_Presupuesto,
    (SELECT COUNT(*) FROM Tbl_Gastos) AS Gastos;