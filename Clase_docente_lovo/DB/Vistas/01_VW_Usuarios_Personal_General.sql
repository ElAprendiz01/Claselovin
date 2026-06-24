USE Presupuesto_Empresarial;
GO

-- Vista para consolidar datos de usuarios
CREATE OR ALTER VIEW VW_Usuarios_Personal_General
AS
SELECT 
    U.Id_Usuario,
    U.Usuario,
    R.Id_Rol,
    R.Nombre AS Nombre_Rol,
    P.Id_Persona,
    (P.Primer_Nombre + ' ' + ISNULL(P.Segundo_Nombre, '') + ' ' + P.Primer_Apellido + ' ' + ISNULL(P.Segundo_Apellido, '')) AS Nombre_Completo,
    P.DNI,
    G_DNI.Nombre AS Tipo_DNI,
    G_GEN.Nombre AS Genero,
    P.Fecha_Nacimiento,
    E.Estado AS Estado_Usuario,
    U.Id_Estado AS Id_Estado_Usuario,
    U.Fecha_Creacion,
    U.Fecha_Modificacion,
    U.Id_Creador,
    U.Id_Modificador
FROM Tbl_Usuarios U (NOLOCK)
INNER JOIN Tbl_Datos_Personales P (NOLOCK) ON U.Id_Persona = P.Id_Persona
INNER JOIN Tbl_Roles R (NOLOCK) ON U.Id_Rol = R.Id_Rol
INNER JOIN Cat_General G_DNI (NOLOCK) ON P.Id_Tipo_DNI = G_DNI.Id_Catalogo
INNER JOIN Cat_General G_GEN (NOLOCK) ON P.Id_Genero = G_GEN.Id_Catalogo
INNER JOIN Cat_Estado E (NOLOCK) ON U.Id_Estado = E.Id_Estado;
GO

SELECT * FROM VW_Usuarios_Personal_General;
GO
