USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Datos_Personales_Eliminar
(
    @Id_Persona INT,
    @Id_Modificador INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validar parametros de entrada
    IF @Id_Persona IS NULL OR @Id_Persona <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID es obligatorio';
        RETURN;
    END;

    IF @Id_Modificador IS NULL OR @Id_Modificador <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modificador es obligatorio';
        RETURN;
    END;

    -- Validar existencia y estado activo de la persona
    DECLARE @ExistePersona INT;

    SELECT @ExistePersona = 1
    FROM Tbl_Datos_Personales p
    INNER JOIN Cat_Estado e ON p.Id_Estado = e.Id_Estado
    WHERE p.Id_Persona = @Id_Persona
      AND e.Estado NOT IN ('Desactivado', 'Inactivo', 'Eliminado')
      AND e.Activo = 1;

    IF @ExistePersona IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La persona no existe o esta inactiva';
        RETURN;
    END;

    -- Validar existencia del modificador activo
    DECLARE @ExisteModificador INT;

    SELECT @ExisteModificador = 1
    FROM Tbl_Usuarios u
    INNER JOIN Cat_Estado e ON u.Id_Estado = e.Id_Estado
    WHERE u.Id_Usuario = @Id_Modificador
      AND e.Estado NOT IN ('Desactivado', 'Inactivo', 'Eliminado')
      AND e.Activo = 1;

    IF @ExisteModificador IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modificador no existe o esta inactivo';
        RETURN;
    END;

    -- Validar integridad con usuarios activos
    IF EXISTS (
        SELECT 1 
        FROM Tbl_Usuarios u
        INNER JOIN Cat_Estado e ON u.Id_Estado = e.Id_Estado
        WHERE u.Id_Persona = @Id_Persona 
          AND e.Estado NOT IN ('Desactivado', 'Inactivo', 'Eliminado')
          AND e.Activo = 1
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La persona tiene una cuenta de usuario activa';
        RETURN;
    END;

    -- Obtener ID de estado inactivo
    DECLARE @Id_Estado_Inactivo INT;

    SELECT TOP 1 @Id_Estado_Inactivo = Id_Estado
    FROM Cat_Estado
    WHERE Estado IN ('Desactivado', 'Inactivo', 'Eliminado')
      AND Activo = 1
    ORDER BY Id_Estado;

    IF @Id_Estado_Inactivo IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'No se encontro estado inactivo en catalogo';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Tbl_Datos_Personales
        SET Id_Estado = @Id_Estado_Inactivo,
            Id_Modificador = @Id_Modificador,
            Fecha_Modificacion = SYSDATETIME()
        WHERE Id_Persona = @Id_Persona;

        -- Inactivar contactos asociados de la persona
        UPDATE Tbl_Contacto
        SET Id_Estado = @Id_Estado_Inactivo,
            Id_Modificador = @Id_Modificador,
            Fecha_Modificacion = SYSDATETIME()
        WHERE Id_Persona = @Id_Persona AND Id_Estado <> @Id_Estado_Inactivo;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Persona inhabilitada correctamente';
        SET @o_templateId = @Id_Persona;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
        SET @o_templateId = NULL;
    END CATCH;
END;
GO

-- Ejemplo ejecucion
DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC sp_Tbl_Datos_Personales_Eliminar
    @Id_Persona = 4,
    @Id_Modificador = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS PersonaIdEliminada;
GO
