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
    M.Codigo_ISO,
    M.Nombre_Moneda,
    M.Simbolo,
    P.Descripcion,
    P.Id_Estado,
    E.Estado AS Nombre_Estado,
    P.Id_Creador,
    P.Id_Modificador,
    P.Fecha_Creacion,
    P.Fecha_Modificacion
FROM Tbl_Presupuestos P (NOLOCK)
INNER JOIN Cat_Monedas M (NOLOCK) ON P.Id_Moneda = M.Id_Moneda
INNER JOIN Cat_Estado E (NOLOCK) ON P.Id_Estado = E.Id_Estado
WHERE P.Id_Estado NOT IN (SELECT Id_Estado FROM Cat_Estado (NOLOCK) WHERE Estado LIKE '%Inactivo%' OR Estado LIKE '%Eliminado%' OR Estado LIKE '%Cancelado%' OR Estado LIKE '%Borrado%' OR Estado LIKE '%Baja%')
  AND M.Activo = 1;
GO

select * from VW_Presupuestos_Cabecera_General