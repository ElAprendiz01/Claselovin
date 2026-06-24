USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Alertas_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Alerta INT = NULL,
    @Id_Presupuesto_Detalle INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
    SELECT 
        A.Id_Alerta,
        A.Id_Presupuesto_Detalle,
        CC.Nombre_Centro,
        D.Nombre_Departamento,
        A.Porcentaje_Consumido,
        A.Mensaje_Alerta,
        A.Fecha_Generada,
        A.Leida,
        A.Id_Estado,
        E.Estado AS Nombre_Estado
    FROM Tbl_Alertas A (NOLOCK)
    INNER JOIN Tbl_Detalle_Presupuesto DP (NOLOCK) ON A.Id_Presupuesto_Detalle = DP.Id_Presupuesto_Detalle
    INNER JOIN Tbl_Centros_Costo CC (NOLOCK) ON DP.Id_Centro_Costo = CC.Id_Centro_Costo
    INNER JOIN Tbl_Departamentos D (NOLOCK) ON CC.Id_Departamento = D.Id_Departamento
    INNER JOIN Cat_Estado E (NOLOCK) ON A.Id_Estado = E.Id_Estado
    WHERE (
        @SearchTerm IS NULL
        OR A.Mensaje_Alerta LIKE '%' + @SearchTerm + '%'
        OR CC.Nombre_Centro LIKE '%' + @SearchTerm + '%'
        OR D.Nombre_Departamento LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND A.Id_Alerta = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Alerta IS NULL OR A.Id_Alerta = @Id_Alerta)
    AND (@Id_Presupuesto_Detalle IS NULL OR A.Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle)
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Alertas_Filtrar;
GO

EXEC sp_Tbl_Alertas_Filtrar @SearchTerm = 'excede';
GO

EXEC sp_Tbl_Alertas_Filtrar @Id_Presupuesto_Detalle = 1;
GO
