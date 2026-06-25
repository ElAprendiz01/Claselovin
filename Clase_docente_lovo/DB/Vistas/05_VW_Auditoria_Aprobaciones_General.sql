USE Presupuesto_Empresarial;
GO

-- Vista para consolidar historico de aprobaciones
CREATE OR ALTER VIEW VW_Auditoria_Aprobaciones_General
AS
SELECT 
    A.Id_Aprobacion,
    A.Id_Presupuesto,
    A.Id_Gasto,
    CONCAT(P.Primer_Nombre, ' ', P.Primer_Apellido) AS Nombre_Aprobador,
    A.Fecha_Decision,
    A.Comentarios,
    CG_RES.Nombre AS Resultado_Aprobacion,
    A.Id_Usuario_Aprobador,
    A.Id_Resultado_Aprobacion,
    A.Fecha_Creacion,
    A.Id_Creador
FROM Tbl_Aprobaciones A (NOLOCK)
INNER JOIN Tbl_Usuarios U (NOLOCK) ON A.Id_Usuario_Aprobador = U.Id_Usuario
INNER JOIN Tbl_Datos_Personales P (NOLOCK) ON U.Id_Persona = P.Id_Persona
INNER JOIN Cat_General CG_RES (NOLOCK) ON A.Id_Resultado_Aprobacion = CG_RES.Id_Catalogo
WHERE U.Id_Estado NOT IN (SELECT Id_Estado FROM Cat_Estado (NOLOCK) WHERE Estado LIKE '%Inactivo%' OR Estado LIKE '%Eliminado%' OR Estado LIKE '%Cancelado%' OR Estado LIKE '%Borrado%' OR Estado LIKE '%Baja%')
  AND P.Id_Estado NOT IN (SELECT Id_Estado FROM Cat_Estado (NOLOCK) WHERE Estado LIKE '%Inactivo%' OR Estado LIKE '%Eliminado%' OR Estado LIKE '%Cancelado%' OR Estado LIKE '%Borrado%' OR Estado LIKE '%Baja%')
  AND CG_RES.Activo = 1;
GO

SELECT * FROM VW_Auditoria_Aprobaciones_General;
GO
