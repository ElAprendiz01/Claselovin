USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Contacto_Crear
(
    @Id_Persona INT,
    @Id_Tipo_Contacto INT,
    @Contacto NVARCHAR(100),
    @Id_Creador INT = NULL,
    @Id_Estado INT,
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
        SET @o_message = 'El ID de la persona es obligatorio';
        RETURN;
    END;

    IF @Id_Tipo_Contacto IS NULL OR @Id_Tipo_Contacto <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de contacto es obligatorio';
        RETURN;
    END;

    IF @Contacto IS NULL OR LTRIM(RTRIM(@Contacto)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El contacto es obligatorio';
        RETURN;
    END;

    IF @Id_Estado IS NULL OR @Id_Estado <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado es obligatorio';
        RETURN;
    END;

    -- Validar existencia de persona activa
    IF NOT EXISTS (SELECT 1 FROM Tbl_Datos_Personales WHERE Id_Persona = @Id_Persona AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La persona no existe o esta inactiva';
        RETURN;
    END;

    -- Validar existencia del tipo de contacto
    IF NOT EXISTS (SELECT 1 FROM Cat_General WHERE Id_Catalogo = @Id_Tipo_Contacto AND Id_Tipo_Catalogo = 3 AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de contacto no existe o esta inactivo';
        RETURN;
    END;

    -- Validar existencia del estado
    IF NOT EXISTS (SELECT 1 FROM Cat_Estado WHERE Id_Estado = @Id_Estado AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado no existe o esta inactivo';
        RETURN;
    END;

    -- Validar creador activo
    IF @Id_Creador IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Creador AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El creador no existe o esta inactivo';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Tbl_Contacto
        (
            Id_Persona,
            Id_Tipo_Contacto,
            Contacto,
            Id_Creador,
            Id_Estado
        )
        VALUES
        (
            @Id_Persona,
            @Id_Tipo_Contacto,
            TRIM(@Contacto),
            @Id_Creador,
            @Id_Estado
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Contacto creado correctamente';
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

EXEC sp_Tbl_Contacto_Crear
    @Id_Persona =3,
    @Id_Tipo_Contacto = 5,
    @Contacto = 'juan.perez@gmail.com',
    @Id_Creador = NULL,
    @Id_Estado = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS ContactoIdGenerado;
GO
