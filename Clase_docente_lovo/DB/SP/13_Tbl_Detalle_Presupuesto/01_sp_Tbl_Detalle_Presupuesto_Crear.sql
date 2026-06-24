USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Detalle_Presupuesto_Crear
(
    @Id_Presupuesto INT,
    @Id_Centro_Costo INT,
    @Id_Categoria_Gasto INT,
    @Monto_Presupuestado DECIMAL(18,2),
    @Id_Creador INT,
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

    IF @Id_Centro_Costo IS NULL OR @Id_Centro_Costo <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El centro de costo es obligatorio';
        RETURN;
    END;

    IF @Id_Categoria_Gasto IS NULL OR @Id_Categoria_Gasto <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La categoria de gasto es obligatoria';
        RETURN;
    END;

    IF @Monto_Presupuestado IS NULL OR @Monto_Presupuestado <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El monto presupuestado debe ser mayor a 0';
        RETURN;
    END;

    IF @Id_Creador IS NULL OR @Id_Creador <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El creador es obligatorio';
        RETURN;
    END;

    -- Validar existencia y estado del presupuesto
    IF NOT EXISTS (SELECT 1 FROM Tbl_Presupuestos WHERE Id_Presupuesto = @Id_Presupuesto AND Id_Estado <> 2)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El presupuesto no existe o esta inactivo';
        RETURN;
    END;

    -- Validar existencia y estado del centro de costo
    IF NOT EXISTS (SELECT 1 FROM Tbl_Centros_Costo WHERE Id_Centro_Costo = @Id_Centro_Costo AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El centro de costo no existe o esta inactivo';
        RETURN;
    END;

    -- Validar existencia de la categoria de gasto activa
    IF NOT EXISTS (SELECT 1 FROM Cat_General WHERE Id_Catalogo = @Id_Categoria_Gasto AND Id_Tipo_Catalogo = 4 AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La categoria de gasto no existe o esta inactiva';
        RETURN;
    END;

    -- Validar creador activo
    IF NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Creador AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El creador no existe o esta inactivo';
        RETURN;
    END;

    -- Validar duplicidad de detalle
    IF EXISTS (
        SELECT 1 
        FROM Tbl_Detalle_Presupuesto 
        WHERE Id_Presupuesto = @Id_Presupuesto 
          AND Id_Centro_Costo = @Id_Centro_Costo 
          AND Id_Categoria_Gasto = @Id_Categoria_Gasto
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe un detalle registrado para esta combinacion';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Tbl_Detalle_Presupuesto
        (
            Id_Presupuesto,
            Id_Centro_Costo,
            Id_Categoria_Gasto,
            Monto_Presupuestado,
            Monto_Ejecutado,
            Id_Creador
        )
        VALUES
        (
            @Id_Presupuesto,
            @Id_Centro_Costo,
            @Id_Categoria_Gasto,
            @Monto_Presupuestado,
            0.00,
            @Id_Creador
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Detalle de presupuesto creado correctamente';
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

EXEC sp_Tbl_Detalle_Presupuesto_Crear
    @Id_Presupuesto = 1,
    @Id_Centro_Costo = 2,
    @Id_Categoria_Gasto = 7,
    @Monto_Presupuestado = 15000.00,
    @Id_Creador = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS DetalleIdGenerado;
GO
