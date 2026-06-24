USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_Tipo_Catalogo_Eliminar
(
    @Id_Tipo_Catalogo INT,
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
    IF @Id_Tipo_Catalogo IS NULL OR @Id_Tipo_Catalogo <= 0
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

    -- Validar existencia y estado activo
    DECLARE @Activo BIT;
    SELECT @Activo = Activo 
    FROM Cat_Tipo_Catalogo 
    WHERE Id_Tipo_Catalogo = @Id_Tipo_Catalogo;

    IF @Activo IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de catalogo especificado no existe';
        RETURN;
    END;

    IF @Activo = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de catalogo ya esta inactivo';
        RETURN;
    END;

    -- Validar modificador activo
    IF NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Modificador AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modificador no existe o esta inactivo';
        RETURN;
    END;

    -- Validar integridad relacional
    IF EXISTS (SELECT 1 FROM Cat_General WHERE Id_Tipo_Catalogo = @Id_Tipo_Catalogo AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de catalogo contiene catalogos generales activos';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Cat_Tipo_Catalogo
        SET Activo = 0,
            Id_Modificador = @Id_Modificador,
            Fecha_Modificacion = SYSDATETIME()
        WHERE Id_Tipo_Catalogo = @Id_Tipo_Catalogo;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Tipo de catalogo eliminado logicamente';
        SET @o_templateId = @Id_Tipo_Catalogo;
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

EXEC sp_Cat_Tipo_Catalogo_Eliminar
    @Id_Tipo_Catalogo = 1,
    @Id_Modificador = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS TipoIdEliminado;
GO
