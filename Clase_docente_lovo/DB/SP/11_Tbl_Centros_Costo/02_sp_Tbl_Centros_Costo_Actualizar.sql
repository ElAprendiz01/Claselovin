USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Centros_Costo_Actualizar
(
    @Id_Centro_Costo INT,
    @Id_Departamento INT = NULL,
    @Nombre_Centro NVARCHAR(100) = NULL,
    @Codigo_Contable NVARCHAR(50) = NULL,
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
    IF @Id_Centro_Costo IS NULL OR @Id_Centro_Costo <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del centro de costo es obligatorio';
        RETURN;
    END;

    IF @Nombre_Centro IS NOT NULL AND LTRIM(RTRIM(@Nombre_Centro)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre del centro de costo no puede estar vacio';
        RETURN;
    END;

    IF @Codigo_Contable IS NOT NULL AND LTRIM(RTRIM(@Codigo_Contable)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El codigo contable no puede estar vacio';
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
            FROM Tbl_Centros_Costo p
            INNER JOIN Cat_Estado e ON p.Id_Estado = e.Id_Estado
            WHERE p.Id_Centro_Costo = @Id_Centro_Costo
              AND e.Estado IN ('Desactivado', 'Inactivo', 'Eliminado', 'Suspendido')
        )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del registro indica que esta inactivo o desactivado. Si cree que es un error, comuniquese con administracion.';
        RETURN;
    END;

    -- Validar existencia del centro de costo
    IF NOT EXISTS (SELECT 1 FROM Tbl_Centros_Costo WHERE Id_Centro_Costo = @Id_Centro_Costo)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El centro de costo especificado no existe';
        RETURN;
    END;

    -- Validar departamento activo si se envia
    IF @Id_Departamento IS NOT NULL
    BEGIN
        DECLARE @DeptoActivo INT;
        SELECT @DeptoActivo = 1
        FROM Tbl_Departamentos d
        INNER JOIN Cat_Estado e ON d.Id_Estado = e.Id_Estado
        WHERE d.Id_Departamento = @Id_Departamento
          AND e.Estado NOT IN ('Desactivado', 'Inactivo', 'Eliminado')
          AND e.Activo = 1;

        IF @DeptoActivo IS NULL
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El departamento no existe o esta inactivo';
            RETURN;
        END;
    END;

    -- Validar duplicidad del codigo contable
    IF @Codigo_Contable IS NOT NULL
    BEGIN
        IF EXISTS (SELECT 1 FROM Tbl_Centros_Costo WHERE Codigo_Contable = TRIM(@Codigo_Contable) AND Id_Centro_Costo <> @Id_Centro_Costo)
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El codigo contable ya esta registrado';
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

        UPDATE Tbl_Centros_Costo
        SET Id_Departamento = COALESCE(@Id_Departamento, Id_Departamento),
            Nombre_Centro = TRIM(COALESCE(@Nombre_Centro, Nombre_Centro)),
            Codigo_Contable = TRIM(COALESCE(@Codigo_Contable, Codigo_Contable)),
            Id_Modificador = @Id_Modificador,
            Fecha_Modificacion = SYSDATETIME(),
            Id_Estado = COALESCE(@Id_Estado, CASE WHEN @ForzarRecuperacion = 1 THEN @Id_Estado_Activo ELSE Id_Estado END)
        WHERE Id_Centro_Costo = @Id_Centro_Costo;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Centro de costo actualizado correctamente';
        SET @o_templateId = @Id_Centro_Costo;
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

EXEC sp_Tbl_Centros_Costo_Actualizar
    @Id_Centro_Costo = 5,
    @Id_Departamento = 1,
    @Nombre_Centro = 'Infraestructura y Cloud',
    @Codigo_Contable = 'CC-TI-03',
    @Id_Modificador = 1,
    @Id_Estado = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS CentroCostoIdModificado;
GO
