USE Presupuesto_Empresarial;
GO

-- Vista para consolidar los ajustes
CREATE OR ALTER VIEW VW_Ajustes_Presupuesto_General
AS
SELECT 
    A.Id_Ajuste,
    A.Id_Presupuesto_Detalle,
    DP.Id_Presupuesto,
    P.Anio_Fiscal,
    CC.Nombre_Centro,
    CG.Nombre AS Nombre_Categoria_Gasto,
    A.Tipo_Ajuste,
    A.Monto_Ajuste,
    A.Justificacion,
    A.Fecha_Ajuste,
    A.Id_Creador
FROM Tbl_Ajustes_Presupuesto A (NOLOCK)
INNER JOIN Tbl_Detalle_Presupuesto DP (NOLOCK) ON A.Id_Presupuesto_Detalle = DP.Id_Presupuesto_Detalle
INNER JOIN Tbl_Presupuestos P (NOLOCK) ON DP.Id_Presupuesto = P.Id_Presupuesto
INNER JOIN Tbl_Centros_Costo CC (NOLOCK) ON DP.Id_Centro_Costo = CC.Id_Centro_Costo
INNER JOIN Cat_General CG (NOLOCK) ON DP.Id_Categoria_Gasto = CG.Id_Catalogo;
GO
