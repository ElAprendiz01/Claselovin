USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Departamentos_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        D.Id_Departamento,
        D.Nombre_Departamento,
        D.Codigo_Softland,
        D.Id_Estado,
        E.Estado AS Nombre_Estado,
        D.Id_Creador,
        D.Id_Modificador,
        D.Fecha_Creacion,
        D.Fecha_Modificacion
    FROM Tbl_Departamentos D (NOLOCK)
    INNER JOIN Cat_Estado E (NOLOCK) ON D.Id_Estado = E.Id_Estado;
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Departamentos_Listar;
GO
