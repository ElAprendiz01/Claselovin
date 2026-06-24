USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Usuarios_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Usuario INT = NULL,
    @Id_Rol INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
    SELECT 
        U.Id_Usuario,
        U.Usuario,
        U.Id_Persona,
        (P.Primer_Nombre + ' ' + ISNULL(P.Segundo_Nombre, '') + ' ' + P.Primer_Apellido + ' ' + ISNULL(P.Segundo_Apellido, '')) AS Nombre_Completo,
        P.DNI,
        U.Id_Rol,
        R.Nombre AS Nombre_Rol,
        U.Id_Estado,
        E.Estado AS Nombre_Estado,
        U.Id_Creador,
        U.Id_Modificador,
        U.Fecha_Creacion,
        U.Fecha_Modificacion
    FROM Tbl_Usuarios U (NOLOCK)
    INNER JOIN Tbl_Datos_Personales P (NOLOCK) ON U.Id_Persona = P.Id_Persona
    INNER JOIN Tbl_Roles R (NOLOCK) ON U.Id_Rol = R.Id_Rol
    INNER JOIN Cat_Estado E (NOLOCK) ON U.Id_Estado = E.Id_Estado
    WHERE (
        @SearchTerm IS NULL
        OR U.Usuario LIKE '%' + @SearchTerm + '%'
        OR P.Primer_Nombre LIKE '%' + @SearchTerm + '%'
        OR P.Primer_Apellido LIKE '%' + @SearchTerm + '%'
        OR R.Nombre LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND U.Id_Usuario = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Usuario IS NULL OR U.Id_Usuario = @Id_Usuario)
    AND (@Id_Rol IS NULL OR U.Id_Rol = @Id_Rol)
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Usuarios_Filtrar;
GO

EXEC sp_Tbl_Usuarios_Filtrar @SearchTerm = 'admin';
GO

EXEC sp_Tbl_Usuarios_Filtrar @Id_Usuario = 1;
GO
