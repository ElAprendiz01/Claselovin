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
    CG_RES.Nombre AS Resultado_Aprobacion
FROM Tbl_Aprobaciones A (NOLOCK)
INNER JOIN Tbl_Usuarios U (NOLOCK) ON A.Id_Usuario_Aprobador = U.Id_Usuario
INNER JOIN Tbl_Datos_Personales P (NOLOCK) ON U.Id_Persona = P.Id_Persona
INNER JOIN Cat_General CG_RES (NOLOCK) ON A.Id_Resultado_Aprobacion = CG_RES.Id_Catalogo;
GO

SELECT * FROM VW_Auditoria_Aprobaciones_General;
GO
