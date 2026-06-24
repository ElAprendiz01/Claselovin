USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_Estado_Actualizar
(
    @Id_Estado INT,
    @Estado NVARCHAR(30),
    @Id_Modificador INT,
    @Activo BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validar parametros de entrada
    IF @Id_Estado IS NULL OR @Id_Estado <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del estado es obligatorio';
        RETURN;
    END;

    IF @Estado IS NULL OR LTRIM(RTRIM(@Estado)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado es obligatorio';
        RETURN;
    END;

    IF @Id_Modificador IS NULL OR @Id_Modificador <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modificador es obligatorio';
        RETURN;
    END;

    IF @Activo IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado activo es obligatorio';
        RETURN;
    END;

    -- Validar existencia del registro
    IF NOT EXISTS (SELECT 1 FROM Cat_Estado WHERE Id_Estado = @Id_Estado)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado especificado no existe';
        RETURN;
    END;

    -- Validar modificador activo
    IF NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Modificador AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modificador no existe o esta inactivo';
        RETURN;
    END;

    -- Validar duplicidad de nombre
    IF EXISTS (SELECT 1 FROM Cat_Estado WHERE Estado = TRIM(@Estado) AND Activo = 1 AND Id_Estado <> @Id_Estado)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otro estado con ese nombre';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Cat_Estado
        SET Estado = TRIM(@Estado),
            Id_Modificador = @Id_Modificador,
            Fecha_Modificacion = SYSDATETIME(),
            Activo = @Activo
        WHERE Id_Estado = @Id_Estado;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Estado actualizado correctamente';
        SET @o_templateId = @Id_Estado;
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

EXEC sp_Cat_Estado_Actualizar
    @Id_Estado = 1,
    @Estado = 'Activo Modificado',
    @Id_Modificador = 1,
    @Activo = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS EstadoIdModificado;
GO
