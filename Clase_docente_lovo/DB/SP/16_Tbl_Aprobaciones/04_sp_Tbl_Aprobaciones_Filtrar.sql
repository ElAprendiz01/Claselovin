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

    SELECT 
        Id_Aprobacion,
        Id_Presupuesto,
        Id_Gasto,
        Id_Usuario_Aprobador,
        Nombre_Aprobador,
		Usuario,
        Fecha_Decision,
        Comentarios,
        Id_Resultado_Aprobacion,
        Resultado_Aprobacion,
        Fecha_Creacion,
        Id_Creador
    FROM VW_Auditoria_Aprobaciones_General (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR Comentarios LIKE '%' + @SearchTerm + '%'
        OR Resultado_Aprobacion LIKE '%' + @SearchTerm + '%'
        OR Usuario LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND Id_Aprobacion = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Aprobacion IS NULL OR Id_Aprobacion = @Id_Aprobacion)
    AND (@Id_Presupuesto IS NULL OR Id_Presupuesto = @Id_Presupuesto)
    AND (@Id_Gasto IS NULL OR Id_Gasto = @Id_Gasto)
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Aprobaciones_Filtrar;
GO

EXEC sp_Tbl_Aprobaciones_Filtrar @SearchTerm = 'ana_finanzas';
GO

EXEC sp_Tbl_Aprobaciones_Filtrar @Id_Gasto = 1;
GO
