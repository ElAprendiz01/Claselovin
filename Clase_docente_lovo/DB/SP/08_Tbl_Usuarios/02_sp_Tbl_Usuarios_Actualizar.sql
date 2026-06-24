USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Usuarios_Actualizar
(
    @Id_Usuario INT,
    @Usuario NVARCHAR(50) = NULL,
    @Contrasena NVARCHAR(255) = NULL,
    @Id_Persona INT = NULL,
    @Id_Rol INT = NULL,
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
    IF @Id_Usuario IS NULL OR @Id_Usuario <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de usuario es obligatorio';
        RETURN;
    END;

    IF @Usuario IS NOT NULL AND LTRIM(RTRIM(@Usuario)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre de usuario no puede estar vacio';
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
            FROM Tbl_Usuarios p
            INNER JOIN Cat_Estado e ON p.Id_Estado = e.Id_Estado
            WHERE p.Id_Usuario = @Id_Usuario
              AND e.Estado IN ('Desactivado', 'Inactivo', 'Eliminado', 'Suspendido')
        )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del registro indica que esta inactivo o desactivado. Si cree que es un error, comuniquese con administracion.';
        RETURN;
    END;

    -- Validar existencia del usuario
    IF NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Usuario)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario especificado no existe';
        RETURN;
    END;

    -- Validar duplicidad de usuario excluyendo actual
    IF @Usuario IS NOT NULL
    BEGIN
        IF EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Usuario = TRIM(@Usuario) AND Id_Usuario <> @Id_Usuario)
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El nombre de usuario ya esta registrado';
            RETURN;
        END;
    END;

    -- Validar persona activa si se envia
    IF @Id_Persona IS NOT NULL
    BEGIN
        DECLARE @PersonaActiva INT;
        SELECT @PersonaActiva = 1
        FROM Tbl_Datos_Personales p
        INNER JOIN Cat_Estado e ON p.Id_Estado = e.Id_Estado
        WHERE p.Id_Persona = @Id_Persona
          AND e.Estado NOT IN ('Desactivado', 'Inactivo', 'Eliminado')
          AND e.Activo = 1;

        IF @PersonaActiva IS NULL
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'La persona no existe o esta inactiva';
            RETURN;
        END;

        -- Validar que la persona no tenga otro usuario
        IF EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Persona = @Id_Persona AND Id_Usuario <> @Id_Usuario)
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'La persona ya tiene asignado otro usuario';
            RETURN;
        END;
    END;

    -- Validar rol activo si se envia
    IF @Id_Rol IS NOT NULL
    BEGIN
        DECLARE @RolActivo INT;
        SELECT @RolActivo = 1
        FROM Tbl_Roles r
        INNER JOIN Cat_Estado e ON r.Id_Estado = e.Id_Estado
        WHERE r.Id_Rol = @Id_Rol
          AND e.Estado NOT IN ('Desactivado', 'Inactivo', 'Eliminado')
          AND e.Activo = 1;

        IF @RolActivo IS NULL
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El rol no existe o esta inactivo';
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

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Obtener ID de estado activo
        DECLARE @Id_Estado_Activo INT;
        SELECT TOP 1 @Id_Estado_Activo = Id_Estado
        FROM Cat_Estado
        WHERE Estado = 'Activo' AND Activo = 1;

        UPDATE Tbl_Usuarios
        SET Usuario = TRIM(COALESCE(@Usuario, Usuario)),
            Contrasena = COALESCE(@Contrasena, Contrasena),
            Id_Persona = COALESCE(@Id_Persona, Id_Persona),
            Id_Rol = COALESCE(@Id_Rol, Id_Rol),
            Id_Modificador = @Id_Modificador,
            Fecha_Modificacion = SYSDATETIME(),
            Id_Estado = COALESCE(@Id_Estado, CASE WHEN @ForzarRecuperacion = 1 THEN @Id_Estado_Activo ELSE Id_Estado END)
        WHERE Id_Usuario = @Id_Usuario;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Usuario actualizado correctamente';
        SET @o_templateId = @Id_Usuario;
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

EXEC sp_Tbl_Usuarios_Actualizar
    @Id_Usuario = 3,
    @Usuario = 'juan_analista',
    @Contrasena = 'cajsbsacjb_nuevo',
    @Id_Persona = 3,
    @Id_Rol = 3,
    @Id_Modificador = 1,
    @Id_Estado = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS UsuarioIdModificado;
GO
