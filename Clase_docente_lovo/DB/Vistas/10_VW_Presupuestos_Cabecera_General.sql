USE Presupuesto_Empresarial;
GO

-- Vista para consolidar cabeceras de presupuesto
CREATE OR ALTER VIEW VW_Presupuestos_Cabecera_General
AS
SELECT 
    P.Id_Presupuesto,
    P.Anio_Fiscal,
    P.Id_Moneda,
    M.Codigo_ISO AS Moneda_ISO,
    M.Simbolo AS Moneda_Simbolo,
    P.Monto_Total,
    P.Descripcion,
    P.Id_Estado,
    E.Estado AS Nombre_Estado,
    P.Id_Creador,
    P.Id_Modificador,
    P.Fecha_Creacion,
    P.Fecha_Modificacion
FROM Tbl_Presupuestos P (NOLOCK)
INNER JOIN Cat_Monedas M (NOLOCK) ON P.Id_Moneda = M.Id_Moneda
INNER JOIN Cat_Estado E (NOLOCK) ON P.Id_Estado = E.Id_Estado;
GO
