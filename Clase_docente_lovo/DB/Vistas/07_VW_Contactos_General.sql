USE Presupuesto_Empresarial;
GO

-- Vista para consolidar contactos
CREATE OR ALTER VIEW VW_Contactos_General
AS
SELECT 
    C.Id_Contacto,
    C.Id_Persona,
    (P.Primer_Nombre + ' ' + P.Primer_Apellido) AS Nombre_Persona,
    C.Id_Tipo_Contacto,
    G.Nombre AS Nombre_Tipo_Contacto,
    C.Contacto,
    C.Id_Estado,
    E.Estado AS Nombre_Estado,
    C.Id_Creador,
    C.Id_Modificador,
    C.Fecha_Creacion,
    C.Fecha_Modificacion
FROM Tbl_Contacto C (NOLOCK)
INNER JOIN Tbl_Datos_Personales P (NOLOCK) ON C.Id_Persona = P.Id_Persona
INNER JOIN Cat_General G (NOLOCK) ON C.Id_Tipo_Contacto = G.Id_Catalogo
INNER JOIN Cat_Estado E (NOLOCK) ON C.Id_Estado = E.Id_Estado;
GO
