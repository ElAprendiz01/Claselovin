USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Permisos_Opciones_Actualizar
(
    @Id_Permiso INT,
    @Id_Rol INT,
    @Modulo NVARCHAR(50),
    @Puede_Crear BIT,
    @Puede_Leer BIT,
    @Puede_Actualizar BIT,
    @Puede_Eliminar BIT,
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

    IF @Id_Rol IS NULL OR @Id_Rol <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El rol es obligatorio';
        RETURN;
    END;

    IF @Modulo IS NULL OR LTRIM(RTRIM(@Modulo)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modulo es obligatorio';
        RETURN;
    END;

    IF @Puede_Crear IS NULL OR @Puede_Leer IS NULL OR @Puede_Actualizar IS NULL OR @Puede_Eliminar IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Los valores de permisos son obligatorios';
        RETURN;
    END;

    -- Validar existencia del permiso
    IF NOT EXISTS (SELECT 1 FROM Tbl_Permisos_Opciones WHERE Id_Permiso = @Id_Permiso)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El permiso especificado no existe';
        RETURN;
    END;

    -- Validar existencia del rol activo
    IF NOT EXISTS (SELECT 1 FROM Tbl_Roles WHERE Id_Rol = @Id_Rol AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El rol no existe o esta inactivo';
        RETURN;
    END;

    -- Validar duplicidad de rol y modulo excluyendo actual
    IF EXISTS (SELECT 1 FROM Tbl_Permisos_Opciones WHERE Id_Rol = @Id_Rol AND Modulo = TRIM(@Modulo) AND Id_Permiso <> @Id_Permiso)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El permiso para este rol y modulo ya existe';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Tbl_Permisos_Opciones
        SET Id_Rol = @Id_Rol,
            Modulo = TRIM(@Modulo),
            Puede_Crear = @Puede_Crear,
            Puede_Leer = @Puede_Leer,
            Puede_Actualizar = @Puede_Actualizar,
            Puede_Eliminar = @Puede_Eliminar
        WHERE Id_Permiso = @Id_Permiso;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Permiso actualizado correctamente';
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

EXEC sp_Tbl_Permisos_Opciones_Actualizar
    @Id_Permiso = 1,
    @Id_Rol = 1,
    @Modulo = 'Todos',
    @Puede_Crear = 1,
    @Puede_Leer = 1,
    @Puede_Actualizar = 1,
    @Puede_Eliminar = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS PermisoIdModificado;
GO
