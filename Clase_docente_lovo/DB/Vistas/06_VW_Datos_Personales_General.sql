USE Presupuesto_Empresarial;
GO

-- Vista para consolidar datos personales
CREATE OR ALTER VIEW VW_Datos_Personales_General
AS
SELECT 
    P.Id_Persona,
    P.Primer_Nombre,
    P.Segundo_Nombre,
    P.Primer_Apellido,
    P.Segundo_Apellido,
    (P.Primer_Nombre + ' ' + ISNULL(P.Segundo_Nombre, '') + ' ' + P.Primer_Apellido + ' ' + ISNULL(P.Segundo_Apellido, '')) AS Nombre_Completo,
    P.DNI,
    P.Id_Tipo_DNI,
    G_DNI.Nombre AS Tipo_DNI,
    P.Id_Genero,
    G_GEN.Nombre AS Genero,
    P.Fecha_Nacimiento,
    P.Id_Estado,
    E.Estado AS Nombre_Estado
FROM Tbl_Datos_Personales P (NOLOCK)
INNER JOIN Cat_General G_DNI (NOLOCK) ON P.Id_Tipo_DNI = G_DNI.Id_Catalogo
INNER JOIN Cat_General G_GEN (NOLOCK) ON P.Id_Genero = G_GEN.Id_Catalogo
INNER JOIN Cat_Estado E (NOLOCK) ON P.Id_Estado = E.Id_Estado;
GO
