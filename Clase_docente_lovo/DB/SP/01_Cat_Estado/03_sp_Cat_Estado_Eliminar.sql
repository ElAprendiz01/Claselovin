USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_Estado_Eliminar
(
    @Id_Estado INT,
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
    IF @Id_Estado IS NULL OR @Id_Estado <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del estado es obligatorio';
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
    FROM Cat_Estado 
    WHERE Id_Estado = @Id_Estado;

    IF @Activo IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado especificado no existe';
        RETURN;
    END;

    IF @Activo = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado ya esta inactivo';
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
    IF EXISTS (SELECT 1 FROM Tbl_Datos_Personales WHERE Id_Estado = @Id_Estado)
        OR EXISTS (SELECT 1 FROM Tbl_Contacto WHERE Id_Estado = @Id_Estado)
        OR EXISTS (SELECT 1 FROM Tbl_Roles WHERE Id_Estado = @Id_Estado)
        OR EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Estado = @Id_Estado)
        OR EXISTS (SELECT 1 FROM Tbl_Departamentos WHERE Id_Estado = @Id_Estado)
        OR EXISTS (SELECT 1 FROM Tbl_Centros_Costo WHERE Id_Estado = @Id_Estado)
        OR EXISTS (SELECT 1 FROM Tbl_Presupuestos WHERE Id_Estado = @Id_Estado)
        OR EXISTS (SELECT 1 FROM Tbl_Gastos WHERE Id_Estado = @Id_Estado)
        OR EXISTS (SELECT 1 FROM Tbl_Alertas WHERE Id_Estado = @Id_Estado)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado esta en uso y no puede desactivarse';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Cat_Estado
        SET Activo = 0,
            Id_Modificador = @Id_Modificador,
            Fecha_Modificacion = SYSDATETIME()
        WHERE Id_Estado = @Id_Estado;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Estado eliminado logicamente';
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

EXEC sp_Cat_Estado_Eliminar
    @Id_Estado = 7,
    @Id_Modificador = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS EstadoIdEliminado;
GO
