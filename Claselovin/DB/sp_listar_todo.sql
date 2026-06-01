USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE Sp_Listar_Inserciones_Sistema
AS
BEGIN
    SET NOCOUNT ON;

    -- =========================================================================
    -- MÓDULO 1: CATALOGOS PRIMARIOS Y MULTIDIVISA
    -- =========================================================================
    PRINT '---------------------------------------------------------------------';
    PRINT 'MÓDULO 1: CATÁLOGOS PRIMARIOS Y CONFIGURACIÓN MULTIDIVISA';
    PRINT '---------------------------------------------------------------------';
    
    SELECT 'Cat_Estado' AS [Tabla], Id_Estado AS [ID], Estado AS [Descripción], Activo FROM Cat_Estado;
    
    SELECT 'Cat_Monedas' AS [Tabla], Id_Moneda AS [ID], Codigo_ISO, Nombre_Moneda, Simbolo FROM Cat_Monedas;
    
    SELECT 'Cat_Tipo_Catalogo' AS [Tabla], Id_Tipo_Catalogo AS [ID], Nombre FROM Cat_Tipo_Catalogo;
    
    SELECT 
        'Cat_General' AS [Tabla], 
        G.Id_Catalogo AS [ID], 
        T.Nombre AS [Tipo_Catalogo], 
        G.Nombre AS [Valor_Catalogo]
    FROM Cat_General G
    INNER JOIN Cat_Tipo_Catalogo T ON G.Id_Tipo_Catalogo = T.Id_Tipo_Catalogo;


    -- =========================================================================
    -- MÓDULO 2: SEGURIDAD, PERSONAL Y MATRIZ DE PERMISOS (RBAC)
    -- =========================================================================
    PRINT '---------------------------------------------------------------------';
    PRINT 'MÓDULO 2: ENTIDADES DE PERSONAL, SEGURIDAD Y MATRIZ DE PERMISOS';
    PRINT '---------------------------------------------------------------------';
    
    SELECT 'Tbl_Roles' AS [Tabla], Id_Rol AS [ID], Nombre, Descripcion FROM Tbl_Roles;
    
    SELECT 
        'Tbl_Datos_Personales' AS [Tabla], 
        Id_Persona AS [ID], 
        (Primer_Nombre + ' ' + ISNULL(Segundo_Nombre, '') + ' ' + Primer_Apellido + ' ' + ISNULL(Segundo_Apellido, '')) AS [Nombre_Completo], 
        DNI, 
        Fecha_Nacimiento 
    FROM Tbl_Datos_Personales;
    
    SELECT 
        'Tbl_Contacto' AS [Tabla], 
        C.Id_Contacto AS [ID], 
        (P.Primer_Nombre + ' ' + P.Primer_Apellido) AS [Persona], 
        G.Nombre AS [Tipo_Contacto], 
        C.Contacto
    FROM Tbl_Contacto C
    INNER JOIN Tbl_Datos_Personales P ON C.Id_Persona = P.Id_Persona
    INNER JOIN Cat_General G ON C.Id_Tipo_Contacto = G.Id_Catalogo;

    SELECT 
        'Tbl_Usuarios' AS [Tabla], 
        U.Id_Usuario AS [ID], 
        U.Usuario, 
        R.Nombre AS [Rol_Asignado], 
        (P.Primer_Nombre + ' ' + P.Primer_Apellido) AS [Empleado]
    FROM Tbl_Usuarios U
    INNER JOIN Tbl_Roles R ON U.Id_Rol = R.Id_Rol
    INNER JOIN Tbl_Datos_Personales P ON U.Id_Persona = P.Id_Persona;

    SELECT 
        'Tbl_Permisos_Opciones' AS [Tabla], 
        P.Id_Permiso AS [ID], 
        R.Nombre AS [Rol], 
        P.Modulo, 
        P.Puede_Crear AS [C], 
        P.Puede_Leer AS [R], 
        P.Puede_Actualizar AS [U], 
        P.Puede_Eliminar AS [D]
    FROM Tbl_Permisos_Opciones P
    INNER JOIN Tbl_Roles R ON P.Id_Rol = R.Id_Rol;


    -- =========================================================================
    -- MÓDULO 3: ESTRUCTURA ORGANIZACIONAL Y PLANIFICACIÓN FINANCIERA
    -- =========================================================================
    PRINT '---------------------------------------------------------------------';
    PRINT 'MÓDULO 3: ESTRUCTURA ORGANIZACIONAL Y PLANIFICACIÓN FINANCIERA';
    PRINT '---------------------------------------------------------------------';
    
    SELECT 'Tbl_Departamentos' AS [Tabla], Id_Departamento AS [ID], Nombre_Departamento, Codigo_Softland FROM Tbl_Departamentos;
    
    SELECT 
        'Tbl_Centros_Costo' AS [Tabla], 
        CC.Id_Centro_Costo AS [ID], 
        D.Nombre_Departamento AS [Departamento], 
        CC.Nombre_Centro, 
        CC.Codigo_Contable 
    FROM Tbl_Centros_Costo CC
    INNER JOIN Tbl_Departamentos D ON CC.Id_Departamento = D.Id_Departamento;

    SELECT 
        'Tbl_Presupuestos' AS [Tabla], 
        P.Id_Presupuesto AS [ID], 
        P.Anio_Fiscal, 
        M.Codigo_ISO AS [Moneda], 
        P.Descripcion, 
        E.Estado 
    FROM Tbl_Presupuestos P
    INNER JOIN Cat_Monedas M ON P.Id_Moneda = M.Id_Moneda
    INNER JOIN Cat_Estado E ON P.Id_Estado = E.Id_Estado;

    SELECT 
        'Tbl_Detalle_Presupuesto' AS [Tabla], 
        DP.Id_Presupuesto_Detalle AS [ID], 
        CC.Nombre_Centro AS [Centro_Costo], 
        CG.Nombre AS [Categoría], 
        DP.Monto_Presupuestado AS [Presupuesto], 
        DP.Monto_Ejecutado AS [Ejecutado]
    FROM Tbl_Detalle_Presupuesto DP
    INNER JOIN Tbl_Centros_Costo CC ON DP.Id_Centro_Costo = CC.Id_Centro_Costo
    INNER JOIN Cat_General CG ON DP.Id_Categoria_Gasto = CG.Id_Catalogo;


    -- =========================================================================
    -- MÓDULO 4: OPERACIONES, AUDITORÍA Y AUTOMATIZACIONES
    -- =========================================================================
    PRINT '---------------------------------------------------------------------';
    PRINT 'MÓDULO 4: OPERACIONES REALES Y AUTOMATIZACIÓN (GASTOS Y ALERTAS)';
    PRINT '---------------------------------------------------------------------';
    
    SELECT 
        'Tbl_Gastos' AS [Tabla], 
        G.Id_Gasto AS [ID], 
        CC.Nombre_Centro AS [Origen_Centro_Costo], 
        G.Descripcion_Gasto, 
        G.Monto_Gasto, 
        G.Fecha_Gasto, 
        G.Numero_Factura
    FROM Tbl_Gastos G
    INNER JOIN Tbl_Detalle_Presupuesto DP ON G.Id_Presupuesto_Detalle = DP.Id_Presupuesto_Detalle
    INNER JOIN Tbl_Centros_Costo CC ON DP.Id_Centro_Costo = CC.Id_Centro_Costo;

    SELECT 
        'Tbl_Aprobaciones' AS [Tabla], 
        A.Id_Aprobacion AS [ID], 
        U.Usuario AS [Aprobador], 
        G.Nombre AS [Resultado], 
        A.Comentarios, 
        A.Fecha_Decision 
    FROM Tbl_Aprobaciones A
    INNER JOIN Tbl_Usuarios U ON A.Id_Usuario_Aprobador = U.Id_Usuario
    INNER JOIN Cat_General G ON A.Id_Resultado_Aprobacion = G.Id_Catalogo;

    SELECT 
        'Tbl_Alertas' AS [Tabla], 
        A.Id_Alerta AS [ID], 
        CC.Nombre_Centro AS [Centro_Costo_Afectado], 
        A.Porcentaje_Consumido, 
        A.Mensaje_Alerta, 
        A.Leida 
    FROM Tbl_Alertas A
    INNER JOIN Tbl_Detalle_Presupuesto DP ON A.Id_Presupuesto_Detalle = DP.Id_Presupuesto_Detalle
    INNER JOIN Tbl_Centros_Costo CC ON DP.Id_Centro_Costo = CC.Id_Centro_Costo;

END;
GO



EXEC Sp_Listar_Inserciones_Sistema;
GO