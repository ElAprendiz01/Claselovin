USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Roles_Actualizar
(
    @Id_Rol INT,
    @Nombre NVARCHAR(50) = NULL,
    @Descripcion NVARCHAR(150) = NULL,
    @Id_Modificador INT,
    @Id_Estado INT = NULL,
    @ForzarRecuperacion BIT = 0,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validar parametros de entrada
    IF @Id_Rol IS NULL OR @Id_Rol <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del rol es obligatorio';
        RETURN;
    END;

    IF @Nombre IS NOT NULL AND LTRIM(RTRIM(@Nombre)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre no puede estar vacio';
        RETURN;
    END;

    IF @Id_Modificador IS NULL OR @Id_Modificador <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modificador es obligatorio';
        RETURN;
    END;

    -- Validar si esta inactivo y @ForzarRecuperacion = 0
    IF @ForzarRecuperacion = 0
        AND EXISTS (
            SELECT 1
            FROM Tbl_Roles p
            INNER JOIN Cat_Estado e ON p.Id_Estado = e.Id_Estado
            WHERE p.Id_Rol = @Id_Rol
              AND e.Estado IN ('Desactivado', 'Inactivo', 'Eliminado', 'Suspendido')
        )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del registro indica que esta inactivo o desactivado. Si cree que es un error, comuniquese con administracion.';
        RETURN;
    END;

    -- Validar existencia de rol
    IF NOT EXISTS (SELECT 1 FROM Tbl_Roles WHERE Id_Rol = @Id_Rol)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El rol especificado no existe';
        RETURN;
    END;

    -- Validar existencia del estado si se envia
    IF @Id_Estado IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Cat_Estado WHERE Id_Estado = @Id_Estado AND Activo = 1)
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El estado no existe o esta inactivo';
            RETURN;
        END;
    END;

    -- Validar modificador activo
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

    -- Validar duplicidad de nombre
    IF @Nombre IS NOT NULL
    BEGIN
        IF EXISTS (
            SELECT 1 
            FROM Tbl_Roles r
            INNER JOIN Cat_Estado e ON r.Id_Estado = e.Id_Estado
            WHERE r.Nombre = TRIM(@Nombre) 
              AND e.Estado NOT IN ('Desactivado', 'Inactivo', 'Eliminado')
              AND r.Id_Rol <> @Id_Rol
        )
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'Ya existe otro rol activo con ese nombre';
            RETURN;
        END;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Obtener ID de estado activo
        DECLARE @Id_Estado_Activo INT;
        SELECT TOP 1 @Id_Estado_Activo = Id_Estado
        FROM Cat_Estado
        WHERE Estado = 'Activo' AND Activo = 1;

        UPDATE Tbl_Roles
        SET Nombre = TRIM(COALESCE(@Nombre, Nombre)),
            Descripcion = TRIM(COALESCE(@Descripcion, Descripcion)),
            Id_Modificador = @Id_Modificador,
            Fecha_Modificacion = SYSDATETIME(),
            Id_Estado = COALESCE(@Id_Estado, CASE WHEN @ForzarRecuperacion = 1 THEN @Id_Estado_Activo ELSE Id_Estado END)
        WHERE Id_Rol = @Id_Rol;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Rol actualizado correctamente';
        SET @o_templateId = @Id_Rol;
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

EXEC sp_Tbl_Roles_Actualizar
    @Id_Rol = 1,
    @Nombre = 'Administrador Modificado',
    @Descripcion = 'Acceso total modificado',
    @Id_Modificador = 1,
    @Id_Estado = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS RolIdModificado;
GO
