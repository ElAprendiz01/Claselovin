USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Presupuestos_Actualizar
(
    @Id_Presupuesto INT,
    @Anio_Fiscal INT = NULL,
    @Id_Moneda INT = NULL,
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
    IF @Id_Presupuesto IS NULL OR @Id_Presupuesto <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del presupuesto es obligatorio';
        RETURN;
    END;

    IF @Anio_Fiscal IS NOT NULL AND @Anio_Fiscal <= 2020
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ano fiscal debe ser mayor a 2020';
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
            FROM Tbl_Presupuestos p
            INNER JOIN Cat_Estado e ON p.Id_Estado = e.Id_Estado
            WHERE p.Id_Presupuesto = @Id_Presupuesto
              AND e.Estado IN ('Desactivado', 'Inactivo', 'Eliminado', 'Suspendido')
        )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del registro indica que esta inactivo o desactivado. Si cree que es un error, comuniquese con administracion.';
        RETURN;
    END;

    -- Validar existencia del presupuesto
    DECLARE @Current_Anio_Fiscal INT;
    DECLARE @Current_Estado INT;
    SELECT @Current_Anio_Fiscal = Anio_Fiscal, @Current_Estado = Id_Estado
    FROM Tbl_Presupuestos
    WHERE Id_Presupuesto = @Id_Presupuesto;

    IF @Current_Estado IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El presupuesto especificado no existe';
        RETURN;
    END;

    -- Bloquear cambios de ano fiscal aprobado
    IF @Current_Estado = 4 AND @Anio_Fiscal IS NOT NULL AND @Current_Anio_Fiscal <> @Anio_Fiscal
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'No se puede cambiar el ano fiscal de un presupuesto aprobado';
        RETURN;
    END;

    -- Validar moneda si se envia
    IF @Id_Moneda IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Cat_Monedas WHERE Id_Moneda = @Id_Moneda AND Activo = 1)
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'La moneda no existe o esta inactiva';
            RETURN;
        END;
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

    -- Validar presupuesto aprobado unico
    DECLARE @EvalAnio INT;
    SET @EvalAnio = COALESCE(@Anio_Fiscal, @Current_Anio_Fiscal);
    DECLARE @EvalEstado INT;
    SET @EvalEstado = COALESCE(@Id_Estado, @Current_Estado);

    IF @EvalEstado = 4 AND EXISTS (SELECT 1 FROM Tbl_Presupuestos WHERE Anio_Fiscal = @EvalAnio AND Id_Estado = 4 AND Id_Presupuesto <> @Id_Presupuesto)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otro presupuesto aprobado para este ano fiscal';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Obtener ID de estado activo
        DECLARE @Id_Estado_Activo INT;
        SELECT TOP 1 @Id_Estado_Activo = Id_Estado
        FROM Cat_Estado
        WHERE Estado = 'Activo' AND Activo = 1;

        UPDATE Tbl_Presupuestos
        SET Anio_Fiscal = COALESCE(@Anio_Fiscal, Anio_Fiscal),
            Id_Moneda = COALESCE(@Id_Moneda, Id_Moneda),
            Descripcion = TRIM(COALESCE(@Descripcion, Descripcion)),
            Id_Modificador = @Id_Modificador,
            Fecha_Modificacion = SYSDATETIME(),
            Id_Estado = COALESCE(@Id_Estado, CASE WHEN @ForzarRecuperacion = 1 THEN @Id_Estado_Activo ELSE Id_Estado END)
        WHERE Id_Presupuesto = @Id_Presupuesto;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Presupuesto actualizado correctamente';
        SET @o_templateId = @Id_Presupuesto;
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

EXEC sp_Tbl_Presupuestos_Actualizar
    @Id_Presupuesto = 1,
    @Anio_Fiscal = 2026,
    @Id_Moneda = 1,
    @Descripcion = 'Presupuesto General Corporativo Ano 2026 Modificado',
    @Id_Modificador = 1,
    @Id_Estado = 4, -- Mantener aprobado
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS PresupuestoIdModificado;
GO
