USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_Estado_Crear
(
    @Estado NVARCHAR(30),
    @Id_Creador INT = NULL,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validar parametros de entrada
    IF @Estado IS NULL OR LTRIM(RTRIM(@Estado)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado es obligatorio';
        RETURN;
    END;

    -- Validar existencia del creador
    IF @Id_Creador IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Creador AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El creador no existe o esta inactivo';
        RETURN;
    END;

    -- Validar duplicidad de nombre
    IF EXISTS (SELECT 1 FROM Cat_Estado WHERE Estado = TRIM(@Estado) AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado ya existe';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Cat_Estado (Estado, Id_Creador, Activo)
        VALUES (TRIM(@Estado), @Id_Creador, 1);

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Estado creado correctamente';
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

EXEC sp_Cat_Estado_Crear
    @Estado = 'Prueba Estado',
    @Id_Creador = NULL,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS EstadoIdGenerado;
GO
