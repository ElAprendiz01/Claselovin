USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_General_Actualizar
(
    @Id_Catalogo INT,
    @Id_Tipo_Catalogo INT,
    @Nombre NVARCHAR(80),
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
    IF @Id_Catalogo IS NULL OR @Id_Catalogo <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID es obligatorio';
        RETURN;
    END;

    IF @Id_Tipo_Catalogo IS NULL OR @Id_Tipo_Catalogo <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de catalogo es obligatorio';
        RETURN;
    END;

    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre es obligatorio';
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
    IF NOT EXISTS (SELECT 1 FROM Cat_General WHERE Id_Catalogo = @Id_Catalogo)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El catalogo general especificado no existe';
        RETURN;
    END;

    -- Validar existencia del tipo de catalogo activo
    IF NOT EXISTS (SELECT 1 FROM Cat_Tipo_Catalogo WHERE Id_Tipo_Catalogo = @Id_Tipo_Catalogo AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de catalogo no existe o esta inactivo';
        RETURN;
    END;

    -- Validar modificador activo
    IF NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Modificador AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modificador no existe o esta inactivo';
        RETURN;
    END;

    -- Validar duplicidad de nombre dentro del mismo tipo
    IF EXISTS (SELECT 1 FROM Cat_General WHERE Id_Tipo_Catalogo = @Id_Tipo_Catalogo AND Nombre = TRIM(@Nombre) AND Activo = 1 AND Id_Catalogo <> @Id_Catalogo)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otro catalogo con este nombre en este tipo';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Cat_General
        SET Id_Tipo_Catalogo = @Id_Tipo_Catalogo,
            Nombre = TRIM(@Nombre),
            Id_Modificador = @Id_Modificador,
            Fecha_Modificacion = SYSDATETIME(),
            Activo = @Activo
        WHERE Id_Catalogo = @Id_Catalogo;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Catalogo general actualizado correctamente';
        SET @o_templateId = @Id_Catalogo;
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

EXEC sp_Cat_General_Actualizar
    @Id_Catalogo = 18,
    @Id_Tipo_Catalogo = 1,
    @Nombre = 'Masculino Modificado',
    @Id_Modificador = 1,
    @Activo = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS CatalogoIdModificado;
GO
