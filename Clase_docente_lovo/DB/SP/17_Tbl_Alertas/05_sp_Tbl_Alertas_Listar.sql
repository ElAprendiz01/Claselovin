USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Alertas_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        Id_Alerta,
        Id_Presupuesto_Detalle,
        Nombre_Centro,
        Nombre_Departamento,
        Porcentaje_Consumido,
        Mensaje_Alerta,
        Fecha_Generada,
        Leida,
        Id_Estado,
        Nombre_Estado
    FROM VW_Alertas_General (NOLOCK);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Alertas_Listar;
GO
