USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_Monedas_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        Id_Moneda,
        Codigo_ISO,
        Nombre_Moneda,
        Simbolo,
        Activo
    FROM Cat_Monedas (NOLOCK);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Cat_Monedas_Listar;
GO
