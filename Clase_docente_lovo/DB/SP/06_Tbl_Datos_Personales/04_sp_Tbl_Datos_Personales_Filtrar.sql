USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Datos_Personales_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Persona INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
    SELECT 
        P.Id_Persona,
        P.Primer_Nombre,
        P.Segundo_Nombre,
        P.Primer_Apellido,
        P.Segundo_Apellido,
        P.Fecha_Nacimiento,
        P.DNI,
        P.Id_Genero,
        G_GEN.Nombre AS Nombre_Genero,
        P.Id_Tipo_DNI,
        G_DNI.Nombre AS Nombre_Tipo_DNI,
        P.Id_Estado,
        E.Estado AS Nombre_Estado,
        P.Id_Creador,
        P.Id_Modificador,
        P.Fecha_Creacion,
        P.Fecha_Modificacion
    FROM Tbl_Datos_Personales P (NOLOCK)
    INNER JOIN Cat_Estado E (NOLOCK) ON P.Id_Estado = E.Id_Estado
    LEFT JOIN Cat_General G_GEN (NOLOCK) ON P.Id_Genero = G_GEN.Id_Catalogo
    LEFT JOIN Cat_General G_DNI (NOLOCK) ON P.Id_Tipo_DNI = G_DNI.Id_Catalogo
    WHERE (
        @SearchTerm IS NULL
        OR P.Primer_Nombre LIKE '%' + @SearchTerm + '%'
        OR P.Primer_Apellido LIKE '%' + @SearchTerm + '%'
        OR P.DNI LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND P.Id_Persona = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Persona IS NULL OR P.Id_Persona = @Id_Persona)
	AND P.Id_Estado NOT IN (
        SELECT Id_Estado 
        FROM Cat_Estado (NOLOCK)
        WHERE Estado LIKE '%Inactivo%'
           OR Estado LIKE '%Eliminado%'
           OR Estado LIKE '%Desactivado%'
           OR Estado LIKE '%Baja%')
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Datos_Personales_Filtrar;
GO

EXEC sp_Tbl_Datos_Personales_Filtrar @SearchTerm = 'Carlos';
GO

EXEC sp_Tbl_Datos_Personales_Filtrar @Id_Persona = 1;
GO
