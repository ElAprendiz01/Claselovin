USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Gastos_Crear
(
    @Id_Presupuesto_Detalle INT,
    @Id_Tipo_Gasto INT,
    @Descripcion_Gasto NVARCHAR(255),
    @Monto_Gasto DECIMAL(18,2),
    @Fecha_Gasto DATETIME2(2) = NULL,
    @Numero_Factura NVARCHAR(50) = NULL,
    @Id_Proveedor INT,
    @Id_Creador INT,
    @Id_Estado INT = 3, -- Por defecto Pendiente Aprobacion (ID: 3)
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validar parametros de entrada
    IF @Id_Presupuesto_Detalle IS NULL OR @Id_Presupuesto_Detalle <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del detalle de presupuesto es obligatorio';
        RETURN;
    END;

    IF @Id_Tipo_Gasto IS NULL OR @Id_Tipo_Gasto <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de gasto es obligatorio';
        RETURN;
    END;

    IF @Descripcion_Gasto IS NULL OR LTRIM(RTRIM(@Descripcion_Gasto)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La descripcion del gasto es obligatoria';
        RETURN;
    END;

    IF @Monto_Gasto IS NULL OR @Monto_Gasto <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El monto del gasto debe ser mayor a 0';
        RETURN;
    END;

    IF @Id_Proveedor IS NULL OR @Id_Proveedor <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El proveedor es obligatorio';
        RETURN;
    END;

    IF @Id_Creador IS NULL OR @Id_Creador <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El creador es obligatorio';
        RETURN;
    END;

    -- Validar existencia y estado del presupuesto padre (debe ser aprobado, ID 4)
    IF NOT EXISTS (
        SELECT 1 
        FROM Tbl_Detalle_Presupuesto DP
        INNER JOIN Tbl_Presupuestos P ON DP.Id_Presupuesto = P.Id_Presupuesto
        WHERE DP.Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle AND P.Id_Estado = 4
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El presupuesto asociado no esta aprobado o no existe';
        RETURN;
    END;

    -- Validar existencia del tipo de gasto
    IF NOT EXISTS (SELECT 1 FROM Cat_General WHERE Id_Catalogo = @Id_Tipo_Gasto AND Id_Tipo_Catalogo = 7 AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de gasto no existe o esta inactivo';
        RETURN;
    END;

    -- Validar existencia del proveedor
    IF NOT EXISTS (SELECT 1 FROM Cat_General WHERE Id_Catalogo = @Id_Proveedor AND Id_Tipo_Catalogo = 6 AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El proveedor no existe o esta inactivo';
        RETURN;
    END;

    -- Validar creador activo
    IF NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Creador AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El creador no existe o esta inactivo';
        RETURN;
    END;

    -- Validar existencia del estado del gasto
    IF NOT EXISTS (SELECT 1 FROM Cat_Estado WHERE Id_Estado = @Id_Estado AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del gasto no existe o esta inactivo';
        RETURN;
    END;

    -- Obtener montos para control de disponibilidad
    DECLARE @Monto_Presupuestado DECIMAL(18,2);
    DECLARE @Monto_Ejecutado DECIMAL(18,2);
    SELECT @Monto_Presupuestado = Monto_Presupuestado, @Monto_Ejecutado = Monto_Ejecutado
    FROM Tbl_Detalle_Presupuesto
    WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;

    -- Control de disponibilidad estricto (debe ser menor al presupuestado debido a constraint)
    IF (@Monto_Ejecutado + @Monto_Gasto) >= @Monto_Presupuestado
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El gasto excede el limite presupuestario disponible';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Determinar auto aprobacion por bajo monto
        DECLARE @Estado_Final INT;
        SET @Estado_Final = @Id_Estado;

        IF @Monto_Gasto <= 100.00 AND @Id_Estado = 3
        BEGIN
            SET @Estado_Final = 4;
        END;

        -- Insertar el gasto
        INSERT INTO Tbl_Gastos
        (
            Id_Presupuesto_Detalle,
            Id_Tipo_Gasto,
            Descripcion_Gasto,
            Monto_Gasto,
            Fecha_Gasto,
            Numero_Factura,
            Id_Proveedor,
            Id_Creador,
            Id_Estado
        )
        VALUES
        (
            @Id_Presupuesto_Detalle,
            @Id_Tipo_Gasto,
            TRIM(@Descripcion_Gasto),
            @Monto_Gasto,
            ISNULL(@Fecha_Gasto, SYSDATETIME()),
            TRIM(@Numero_Factura),
            @Id_Proveedor,
            @Id_Creador,
            @Estado_Final
        );

        SET @o_templateId = SCOPE_IDENTITY();

        -- Registrar aprobacion automatica si aplica
        IF @Estado_Final = 4 AND @Id_Estado = 3
        BEGIN
            INSERT INTO Tbl_Aprobaciones
            (
                Id_Gasto,
                Id_Usuario_Aprobador,
                Fecha_Decision,
                Id_Resultado_Aprobacion,
                Comentarios,
                Id_Creador
            )
            VALUES
            (
                @o_templateId,
                @Id_Creador,
                SYSDATETIME(),
                11,
                'Auto aprobado por el sistema por bajo monto',
                @Id_Creador
            );
        END;

        -- Actualizar el monto ejecutado del detalle
        UPDATE Tbl_Detalle_Presupuesto
        SET Monto_Ejecutado = Monto_Ejecutado + @Monto_Gasto,
            Fecha_Modificacion = SYSDATETIME(),
            Id_Modificador = @Id_Creador
        WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;

        -- Calcular nuevo porcentaje de ejecucion
        DECLARE @Nuevo_Monto_Ejecutado DECIMAL(18,2);
        SELECT @Nuevo_Monto_Ejecutado = Monto_Ejecutado 
        FROM Tbl_Detalle_Presupuesto 
        WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;

        DECLARE @Porcentaje DECIMAL(5,2);
        SET @Porcentaje = (@Nuevo_Monto_Ejecutado / @Monto_Presupuestado) * 100.00;

        -- Alerta automatica si supera el 85%
        IF @Porcentaje > 85.00
        BEGIN
            DECLARE @v_alerta_code INT;
            DECLARE @v_alerta_message VARCHAR(255);
            DECLARE @v_alerta_id INT;

            EXEC sp_Tbl_Alertas_Crear
                @Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle,
                @Porcentaje_Consumido = @Porcentaje,
                @Mensaje_Alerta = 'Consumo de presupuesto excede el 85 por ciento',
                @Id_Estado = 1,
                @o_code = @v_alerta_code OUTPUT,
                @o_message = @v_alerta_message OUTPUT,
                @o_templateId = @v_alerta_id OUTPUT;

            IF @v_alerta_code <> 200
            BEGIN
                SET @o_code = @v_alerta_code;
                SET @o_message = @v_alerta_message;
                ROLLBACK TRANSACTION;
                RETURN;
            END;
        END;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Gasto registrado correctamente';
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

EXEC sp_Tbl_Gastos_Crear
    @Id_Presupuesto_Detalle = 1,
    @Id_Tipo_Gasto = 16,
    @Descripcion_Gasto = 'Soporte AWS Junio 2026',
    @Monto_Gasto = 1000.00,
    @Id_Proveedor = 13,
    @Id_Creador = 3,
    @Id_Estado = 3,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS GastoIdGenerado;
GO
