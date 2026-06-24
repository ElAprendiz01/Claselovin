USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Aprobaciones_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Aprobacion INT = NULL,
    @Id_Presupuesto INT = NULL,
    @Id_Gasto INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
    SELECT 
        A.Id_Aprobacion,
        A.Id_Presupuesto,
        A.Id_Gasto,
        A.Id_Usuario_Aprobador,
        (P.Primer_Nombre + ' ' + P.Primer_Apellido) AS Nombre_Aprobador,
        A.Fecha_Decision,
        A.Comentarios,
        A.Id_Resultado_Aprobacion,
        CG_RES.Nombre AS Resultado_Aprobacion,
        A.Fecha_Creacion,
        A.Id_Creador
    FROM Tbl_Aprobaciones A (NOLOCK)
    INNER JOIN Tbl_Usuarios U (NOLOCK) ON A.Id_Usuario_Aprobador = U.Id_Usuario
    INNER JOIN Tbl_Datos_Personales P (NOLOCK) ON U.Id_Persona = P.Id_Persona
    INNER JOIN Cat_General CG_RES (NOLOCK) ON A.Id_Resultado_Aprobacion = CG_RES.Id_Catalogo
    WHERE (
        @SearchTerm IS NULL
        OR A.Comentarios LIKE '%' + @SearchTerm + '%'
        OR CG_RES.Nombre LIKE '%' + @SearchTerm + '%'
        OR U.Usuario LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND A.Id_Aprobacion = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Aprobacion IS NULL OR A.Id_Aprobacion = @Id_Aprobacion)
    AND (@Id_Presupuesto IS NULL OR A.Id_Presupuesto = @Id_Presupuesto)
    AND (@Id_Gasto IS NULL OR A.Id_Gasto = @Id_Gasto)
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Aprobaciones_Filtrar;
GO

EXEC sp_Tbl_Aprobaciones_Filtrar @SearchTerm = 'Autorizado';
GO

EXEC sp_Tbl_Aprobaciones_Filtrar @Id_Gasto = 1;
GO
