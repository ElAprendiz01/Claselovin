USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_Estado_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        Id_Estado,
        Estado,
        Fecha_Creacion,
        Fecha_Modificacion,
        Id_Creador,
        Id_Modificador,
        Activo
    FROM Cat_Estado (NOLOCK);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Cat_Estado_Listar;
GO
