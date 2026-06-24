USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_General_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        G.Id_Catalogo,
        G.Id_Tipo_Catalogo,
        T.Nombre AS Tipo_Catalogo,
        G.Nombre,
        G.Fecha_Creacion,
        G.Fecha_Modificacion,
        G.Id_Creador,
        G.Id_Modificador,
        G.Activo
    FROM Cat_General G (NOLOCK)
    INNER JOIN Cat_Tipo_Catalogo T (NOLOCK) ON G.Id_Tipo_Catalogo = T.Id_Tipo_Catalogo;
END;
GO

-- Ejemplo ejecucion
EXEC sp_Cat_General_Listar;
GO
