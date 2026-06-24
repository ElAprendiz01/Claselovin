USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Gastos_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        Id_Gasto,
        Descripcion_Gasto,
        Monto_Gasto,
        Fecha_Gasto,
        Numero_Factura,
        Id_Proveedor,
        Proveedor,
        Id_Tipo_Gasto,
        Tipo_Gasto,
        Id_Presupuesto_Detalle,
        Id_Presupuesto,
        Anio_Fiscal,
        Nombre_Centro,
        Nombre_Departamento,
        Id_Estado_Gasto AS Id_Estado,
        Estado_Gasto AS Nombre_Estado,
        Id_Creador,
        Fecha_Creacion
    FROM VW_Gastos_Transaccionales_General (NOLOCK);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Gastos_Listar;
GO
