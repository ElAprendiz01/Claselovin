USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Alertas_Eliminar
(
    @Id_Alerta INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validar parametros de entrada
    IF @Id_Alerta IS NULL OR @Id_Alerta <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la alerta es obligatorio';
        RETURN;
    END;

    -- Validar existencia y estado activo de la alerta
    DECLARE @ExisteAlerta INT;

    SELECT @ExisteAlerta = 1
    FROM Tbl_Alertas a
    INNER JOIN Cat_Estado e ON a.Id_Estado = e.Id_Estado
    WHERE a.Id_Alerta = @Id_Alerta
      AND e.Estado NOT IN ('Desactivado', 'Inactivo', 'Eliminado')
      AND e.Activo = 1;

    IF @ExisteAlerta IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La alerta no existe o esta inactiva';
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

        -- Desactivar y marcar como leida
        UPDATE Tbl_Alertas
        SET Id_Estado = @Id_Estado_Inactivo,
            Leida = 1
        WHERE Id_Alerta = @Id_Alerta;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Alerta inhabilitada correctamente';
        SET @o_templateId = @Id_Alerta;
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

EXEC sp_Tbl_Alertas_Eliminar
    @Id_Alerta = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS AlertaIdEliminado;
GO
