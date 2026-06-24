USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_Tipo_Catalogo_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        Id_Tipo_Catalogo,
        Nombre,
        Fecha_Creacion,
        Fecha_Modificacion,
        Id_Creador,
        Id_Modificador,
        Activo
    FROM Cat_Tipo_Catalogo (NOLOCK);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Cat_Tipo_Catalogo_Listar;
GO
