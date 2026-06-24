USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Permisos_Opciones_Eliminar
(
    @Id_Permiso INT,
    @Id_Usuario_Ejecutor INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validar parametros de entrada
    IF @Id_Permiso IS NULL OR @Id_Permiso <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del permiso es obligatorio';
        RETURN;
    END;

    IF @Id_Usuario_Ejecutor IS NULL OR @Id_Usuario_Ejecutor <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario ejecutor es obligatorio';
        RETURN;
    END;

    -- Validar existencia del permiso
    IF NOT EXISTS (SELECT 1 FROM Tbl_Permisos_Opciones WHERE Id_Permiso = @Id_Permiso)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El permiso especificado no existe';
        RETURN;
    END;

    -- Validar que el ejecutor sea un administrador activo (Rol 1, Estado 1)
    IF NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Usuario_Ejecutor AND Id_Rol = 1 AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Acceso denegado: Se requiere rol de administrador activo';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM Tbl_Permisos_Opciones
        WHERE Id_Permiso = @Id_Permiso;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Permiso eliminado permanentemente';
        SET @o_templateId = @Id_Permiso;
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

EXEC sp_Tbl_Permisos_Opciones_Eliminar
    @Id_Permiso = 5, -- Asumiendo un ID temporal
    @Id_Usuario_Ejecutor = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS PermisoIdEliminado;
GO
