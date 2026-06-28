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
    @Id_Estado INT = NULL, -- Lo dejamos NULL para manejarlo dinámicamente YA VERAN COMO LO HACEMOS ESO MAS ADELANTE APLICAMOS UNA LOGICA BRUTAL
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;


    -- VALIDACIONES DE ENTRADA
  
    IF @Id_Presupuesto_Detalle IS NULL OR @Id_Presupuesto_Detalle <= 0
    BEGIN
        SET @o_code = -1; SET @o_message = 'El ID del detalle de presupuesto es obligatorio';
        RETURN;
    END;

    IF @Id_Tipo_Gasto IS NULL OR @Id_Tipo_Gasto <= 0
    BEGIN
        SET @o_code = -1; SET @o_message = 'El tipo de gasto es obligatorio';
        RETURN;
    END;

    IF @Descripcion_Gasto IS NULL OR LTRIM(RTRIM(@Descripcion_Gasto)) = ''
    BEGIN
        SET @o_code = -1; SET @o_message = 'La descripcion del gasto es obligatoria';
        RETURN;
    END;

    IF @Monto_Gasto IS NULL OR @Monto_Gasto <= 0
    BEGIN
        SET @o_code = -1; SET @o_message = 'El monto del gasto debe ser mayor a 0';
        RETURN;
    END;

    IF @Id_Proveedor IS NULL OR @Id_Proveedor <= 0
    BEGIN
        SET @o_code = -1; SET @o_message = 'El proveedor es obligatorio';
        RETURN;
    END;

    IF @Id_Creador IS NULL OR @Id_Creador <= 0
    BEGIN
        SET @o_code = -1; SET @o_message = 'El creador es obligatorio';
        RETURN;
    END;

    -- Validar existencia y estado del presupuesto padre (debe ser aprobado)
    -- Buscaremos el ID de 'Aprobado' dinámicamente para la validación
    DECLARE @Id_Estado_Aprobado INT;
    DECLARE @Id_Estado_Pendiente INT;
    DECLARE @Id_Resultado_Autorizado INT;

    SELECT TOP 1 @Id_Estado_Aprobado = Id_Estado FROM Cat_Estado WHERE Estado = 'Aprobado' AND Activo = 1;
    SELECT TOP 1 @Id_Estado_Pendiente = Id_Estado FROM Cat_Estado WHERE Estado = 'Pendiente' AND Activo = 1;
    SELECT TOP 1 @Id_Resultado_Autorizado = Id_Catalogo FROM Cat_General WHERE Nombre = 'Autorizado' AND Id_Tipo_Catalogo = 5 AND Activo = 1;

    IF @Id_Estado_Aprobado IS NULL OR @Id_Estado_Pendiente IS NULL OR @Id_Resultado_Autorizado IS NULL
    BEGIN
        SET @o_code = -1; SET @o_message = 'Error: Estructura de catálogos corrupta o incompleta.';
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1 
        FROM Tbl_Detalle_Presupuesto DP
        INNER JOIN Tbl_Presupuestos P ON DP.Id_Presupuesto = P.Id_Presupuesto
        WHERE DP.Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle AND P.Id_Estado = @Id_Estado_Aprobado
    )
    BEGIN
        SET @o_code = -1; SET @o_message = 'El presupuesto asociado no esta aprobado o no existe';
        RETURN;
    END;

    -- Validar existencia del tipo de gasto (Tipo 7)
    IF NOT EXISTS (SELECT 1 FROM Cat_General WHERE Id_Catalogo = @Id_Tipo_Gasto AND Id_Tipo_Catalogo = 7 AND Activo = 1)
    BEGIN
        SET @o_code = -1; SET @o_message = 'El tipo de gasto no existe o esta inactivo';
        RETURN;
    END;

  DECLARE @Id_Tipo_Proveedor INT;
    SELECT TOP 1 @Id_Tipo_Proveedor = Id_Tipo_Catalogo 
    FROM Cat_Tipo_Catalogo 
    WHERE Nombre in ( 'Proveedores', 'proveedor' )AND Activo = 1; 

    -- 2. Validar existencia del proveedor usando la variable
    IF NOT EXISTS (
        SELECT 1 
        FROM Cat_General 
        WHERE Id_Catalogo = @Id_Proveedor 
          AND Id_Tipo_Catalogo = @Id_Tipo_Proveedor 
          AND Activo = 1
    )
    BEGIN
        SET @o_code = -1; 
        SET @o_message = 'El proveedor no existe, está inactivo o no pertenece al catálogo de proveedores';
        RETURN;
    END;

    -- Validar creador activo
    IF NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Creador AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1; SET @o_message = 'El creador no existe o esta inactivo';
        RETURN;
    END;

    -- Obtener montos para control de disponibilidad
    DECLARE @Monto_Presupuestado DECIMAL(18,2);
    DECLARE @Monto_Ejecutado DECIMAL(18,2);
    SELECT @Monto_Presupuestado = Monto_Presupuestado, @Monto_Ejecutado = Monto_Ejecutado
    FROM Tbl_Detalle_Presupuesto
    WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;

    -- Control de disponibilidad estricto
    IF (@Monto_Ejecutado + @Monto_Gasto) >= @Monto_Presupuestado
    BEGIN
        SET @o_code = -1; SET @o_message = 'El gasto excede el limite presupuestario disponible';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        --  DETERMINAR ESTADO INICIAL DINÁMICAMENTE 
        DECLARE @Estado_Final INT;
        
        -- Si viene un estado específico por parámetro se respeta, si no, por defecto es Pendiente SEGUN LA LOGICA DE MI TIA LA FINANCIERA JAJAJ
        SET @Id_Estado = ISNULL(@Id_Estado, @Id_Estado_Pendiente);

        -- Regla de Auto Aprobación por bajo monto (menor o igual a $100.00)
        IF @Monto_Gasto <= 100.00 AND @Id_Estado = @Id_Estado_Pendiente
        BEGIN
            SET @Estado_Final = @Id_Estado_Aprobado;
        END;
        ELSE
        BEGIN
            SET @Estado_Final = @Id_Estado;
        END;

        -- Insertar el gasto
        INSERT INTO Tbl_Gastos
        (
            Id_Presupuesto_Detalle, Id_Tipo_Gasto, Descripcion_Gasto, Monto_Gasto,
            Fecha_Gasto, Numero_Factura, Id_Proveedor, Id_Creador, Id_Estado
        )
        VALUES
        (
            @Id_Presupuesto_Detalle, @Id_Tipo_Gasto, TRIM(@Descripcion_Gasto), @Monto_Gasto,
            ISNULL(@Fecha_Gasto, SYSDATETIME()), TRIM(@Numero_Factura), @Id_Proveedor, @Id_Creador, @Estado_Final
        );

        SET @o_templateId = SCOPE_IDENTITY();

        -- Solo alteramos la billetera de la empresa SI el gasto quedó como APROBADO automáticamente
        IF @Estado_Final = @Id_Estado_Aprobado
        BEGIN
            -- 1. Insertar aprobación automática del sistema
            INSERT INTO Tbl_Aprobaciones
            (
                Id_Gasto, Id_Usuario_Aprobador, Fecha_Decision,
                Id_Resultado_Aprobacion, Comentarios, Id_Creador
            )
            VALUES
            (
                @o_templateId, @Id_Creador, SYSDATETIME(),
                @Id_Resultado_Autorizado, 'Auto aprobado por el sistema por bajo monto', @Id_Creador
            );

            -- 2. Modificar el monto ejecutado real
            UPDATE Tbl_Detalle_Presupuesto
            SET Monto_Ejecutado = Monto_Ejecutado + @Monto_Gasto,
                Fecha_Modificacion = SYSDATETIME(),
                Id_Modificador = @Id_Creador
            WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;

            -- 3. Calcular alertas solo si se sumó dinero
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
    @Id_Presupuesto_Detalle = 2,
    @Id_Tipo_Gasto = 16,
    @Descripcion_Gasto = 'Soporte AWS Junio 2026',
    @Monto_Gasto = 20.00,
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


select * from Tbl_Ajustes_Presupuesto
select * from Tbl_Detalle_Presupuesto