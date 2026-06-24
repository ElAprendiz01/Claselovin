USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Departamentos_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Departamento INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
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
    INNER JOIN Cat_Estado E (NOLOCK) ON D.Id_Estado = E.Id_Estado
    WHERE (
        @SearchTerm IS NULL
        OR D.Nombre_Departamento LIKE '%' + @SearchTerm + '%'
        OR D.Codigo_Softland LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND D.Id_Departamento = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Departamento IS NULL OR D.Id_Departamento = @Id_Departamento)
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Departamentos_Filtrar;
GO

EXEC sp_Tbl_Departamentos_Filtrar @SearchTerm = 'Tecnologías';
GO

EXEC sp_Tbl_Departamentos_Filtrar @Id_Departamento = 1;
GO
