USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Contacto_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Contacto INT = NULL,
    @Id_Persona INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
    SELECT 
        C.Id_Contacto,
        C.Id_Persona,
        (P.Primer_Nombre + ' ' + P.Primer_Apellido) AS Nombre_Persona,
        C.Id_Tipo_Contacto,
        G.Nombre AS Nombre_Tipo_Contacto,
        C.Contacto,
        C.Id_Estado,
        E.Estado AS Nombre_Estado,
        C.Id_Creador,
        C.Id_Modificador,
        C.Fecha_Creacion,
        C.Fecha_Modificacion
    FROM Tbl_Contacto C (NOLOCK)
    INNER JOIN Tbl_Datos_Personales P (NOLOCK) ON C.Id_Persona = P.Id_Persona
    INNER JOIN Cat_General G (NOLOCK) ON C.Id_Tipo_Contacto = G.Id_Catalogo
    INNER JOIN Cat_Estado E (NOLOCK) ON C.Id_Estado = E.Id_Estado
    WHERE (
        @SearchTerm IS NULL
        OR C.Contacto LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND C.Id_Contacto = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Contacto IS NULL OR C.Id_Contacto = @Id_Contacto)
    AND (@Id_Persona IS NULL OR C.Id_Persona = @Id_Persona)
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Contacto_Filtrar;
GO

EXEC sp_Tbl_Contacto_Filtrar @SearchTerm = 'carlos';
GO

EXEC sp_Tbl_Contacto_Filtrar @Id_Persona = 1;
GO
