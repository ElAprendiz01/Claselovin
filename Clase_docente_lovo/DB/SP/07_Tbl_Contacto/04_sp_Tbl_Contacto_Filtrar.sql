USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Contacto_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        Id_Contacto,
        Id_Persona,
        Nombre_Persona,
        Id_Tipo_Contacto,
        Nombre_Tipo_Contacto,
        Contacto,
        Id_Estado,
        Nombre_Estado,
        Id_Creador,
        Id_Modificador,
        Fecha_Creacion,
        Fecha_Modificacion
    FROM VW_Contactos_General (NOLOCK);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Contacto_Listar;
GO


-- Ejemplo ejecucion
EXEC sp_Tbl_Contacto_Filtrar;
GO

EXEC sp_Tbl_Contacto_Filtrar @SearchTerm = 'carlos';
GO

EXEC sp_Tbl_Contacto_Filtrar @Id_Persona = 1;
GO
