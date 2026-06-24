USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Centros_Costo_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        Id_Centro_Costo,
        Id_Departamento,
        Nombre_Departamento,
        Nombre_Centro,
        Codigo_Centro AS Codigo_Contable,
        Id_Estado_Centro AS Id_Estado,
        Estado_Centro AS Nombre_Estado,
        Id_Creador,
        Id_Modificador,
        Fecha_Creacion,
        Fecha_Modificacion
    FROM VW_Estructura_Organizacional_General (NOLOCK);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Centros_Costo_Listar;
GO
