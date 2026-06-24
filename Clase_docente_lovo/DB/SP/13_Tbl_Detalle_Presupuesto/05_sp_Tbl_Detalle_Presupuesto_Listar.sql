USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Detalle_Presupuesto_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        Id_Presupuesto_Detalle,
        Id_Presupuesto,
        Anio_Fiscal,
        Id_Centro_Costo,
        Nombre_Centro,
        Codigo_Centro AS Codigo_Contable,
        Id_Departamento,
        Nombre_Departamento,
        Id_Categoria_Gasto,
        Categoria_Gasto AS Nombre_Categoria_Gasto,
        Monto_Presupuestado,
        Monto_Ejecutado,
        Saldo_Disponible,
        Id_Creador,
        Id_Modificador,
        Fecha_Creacion,
        Fecha_Modificacion
    FROM VW_Presupuestos_Detalle_General (NOLOCK);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Detalle_Presupuesto_Listar;
GO
