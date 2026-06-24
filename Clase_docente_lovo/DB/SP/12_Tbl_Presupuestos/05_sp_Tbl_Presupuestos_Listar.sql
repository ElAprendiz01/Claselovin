USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Presupuestos_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        Id_Presupuesto,
        Anio_Fiscal,
        Id_Moneda,
        Codigo_ISO,
        Nombre_Moneda,
        Simbolo,
        Descripcion,
        Id_Estado,
        Nombre_Estado,
        Id_Creador,
        Id_Modificador,
        Fecha_Creacion,
        Fecha_Modificacion
    FROM VW_Presupuestos_Cabecera_General (NOLOCK);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Presupuestos_Listar;
GO
