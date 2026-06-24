USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Ajustes_Presupuesto_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        Id_Ajuste,
        Id_Presupuesto_Detalle,
        Id_Presupuesto,
        Anio_Fiscal,
        Nombre_Centro,
        Nombre_Categoria_Gasto,
        Tipo_Ajuste,
        Monto_Ajuste,
        Justificacion,
        Fecha_Ajuste,
        Id_Creador
    FROM VW_Ajustes_Presupuesto_General (NOLOCK);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Ajustes_Presupuesto_Listar;
GO
