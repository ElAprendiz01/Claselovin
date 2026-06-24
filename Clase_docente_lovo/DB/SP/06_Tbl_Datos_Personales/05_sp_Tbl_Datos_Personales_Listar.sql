USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Datos_Personales_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        Id_Persona,
        Primer_Nombre,
        Segundo_Nombre,
        Primer_Apellido,
        Segundo_Apellido,
        Nombre_Completo,
        DNI,
        Id_Tipo_DNI,
        Tipo_DNI AS Nombre_Tipo_DNI,
        Id_Genero,
        Genero AS Nombre_Genero,
        Fecha_Nacimiento,
        Id_Estado,
        Nombre_Estado,
        Id_Creador,
        Id_Modificador,
        Fecha_Creacion,
        Fecha_Modificacion
    FROM VW_Datos_Personales_General (NOLOCK);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Datos_Personales_Listar;
GO
