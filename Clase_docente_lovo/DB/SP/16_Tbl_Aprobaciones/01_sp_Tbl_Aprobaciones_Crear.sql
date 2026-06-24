USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Aprobaciones_Crear
(
    @Id_Presupuesto INT = NULL,
    @Id_Gasto INT = NULL,
    @Id_Usuario_Aprobador INT,
    @Id_Resultado_Aprobacion INT,
    @Comentarios NVARCHAR(255) = NULL,
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
    IF (@Id_Presupuesto IS NULL AND @Id_Gasto IS NULL) OR (@Id_Presupuesto IS NOT NULL AND @Id_Gasto IS NOT NULL)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Debe vincular un presupuesto o un gasto, pero no ambos';
        RETURN;
    END;

    IF @Id_Usuario_Aprobador IS NULL OR @Id_Usuario_Aprobador <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El aprobador es obligatorio';
        RETURN;
    END;

    IF @Id_Resultado_Aprobacion IS NULL OR @Id_Resultado_Aprobacion <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El resultado de la aprobacion es obligatorio';
        RETURN;
    END;

    IF @Id_Creador IS NULL OR @Id_Creador <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El creador es obligatorio';
        RETURN;
    END;

    -- Validar aprobador activo y con rol autorizado (Administrador: 1, Gerente Financiero: 2)
    IF NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Usuario_Aprobador AND Id_Rol IN (1, 2) AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El aprobador no esta autorizado o esta inactivo';
        RETURN;
    END;

    -- Validar creador activo
    IF NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Creador AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El creador no existe o esta inactivo';
        RETURN;
    END;

    -- Validar resultado de aprobacion (Tipo catalogo 5)
    IF NOT EXISTS (SELECT 1 FROM Cat_General WHERE Id_Catalogo = @Id_Resultado_Aprobacion AND Id_Tipo_Catalogo = 5 AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El resultado de aprobacion especificado no existe o esta inactivo';
        RETURN;
    END;

    -- Declarar variables para control de estados
    DECLARE @Entidad_Estado INT;
    DECLARE @Monto_Gasto DECIMAL(18,2);
    DECLARE @Id_Presupuesto_Detalle INT;

    -- Validaciones especificas por entidad
    IF @Id_Presupuesto IS NOT NULL
    BEGIN
        SELECT @Entidad_Estado = Id_Estado 
        FROM Tbl_Presupuestos 
        WHERE Id_Presupuesto = @Id_Presupuesto;

        IF @Entidad_Estado IS NULL
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El presupuesto especificado no existe';
            RETURN;
        END;

        IF @Entidad_Estado <> 3 -- Pendiente Aprobacion
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El presupuesto no esta en estado pendiente de aprobacion';
            RETURN;
        END;
    END;
    ELSE IF @Id_Gasto IS NOT NULL
    BEGIN
        SELECT @Entidad_Estado = Id_Estado, 
               @Monto_Gasto = Monto_Gasto,
               @Id_Presupuesto_Detalle = Id_Presupuesto_Detalle
        FROM Tbl_Gastos 
        WHERE Id_Gasto = @Id_Gasto;

        IF @Entidad_Estado IS NULL
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El gasto especificado no existe';
            RETURN;
        END;

        IF @Entidad_Estado <> 3 -- Pendiente Aprobacion
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El gasto no esta en estado pendiente de aprobacion';
            RETURN;
        END;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insertar registro de aprobacion
        INSERT INTO Tbl_Aprobaciones
        (
            Id_Presupuesto,
            Id_Gasto,
            Id_Usuario_Aprobador,
            Fecha_Decision,
            Id_Resultado_Aprobacion,
            Comentarios,
            Id_Creador
        )
        VALUES
        (
            @Id_Presupuesto,
            @Id_Gasto,
            @Id_Usuario_Aprobador,
            SYSDATETIME(),
            @Id_Resultado_Aprobacion,
            TRIM(@Comentarios),
            @Id_Creador
        );

        SET @o_templateId = SCOPE_IDENTITY();

        -- Determinar nuevo estado (4: Aprobado, 5: Rechazado)
        DECLARE @Nuevo_Estado INT;
        IF @Id_Resultado_Aprobacion = 11 -- Autorizado
            SET @Nuevo_Estado = 4; -- Aprobado
        ELSE
            SET @Nuevo_Estado = 5; -- Rechazado

        -- Actualizar estado de la entidad correspondiente
        IF @Id_Presupuesto IS NOT NULL
        BEGIN
            UPDATE Tbl_Presupuestos
            SET Id_Estado = @Nuevo_Estado,
                Fecha_Modificacion = SYSDATETIME(),
                Id_Modificador = @Id_Usuario_Aprobador
            WHERE Id_Presupuesto = @Id_Presupuesto;
        END;
        ELSE IF @Id_Gasto IS NOT NULL
        BEGIN
            UPDATE Tbl_Gastos
            SET Id_Estado = @Nuevo_Estado
            WHERE Id_Gasto = @Id_Gasto;

            -- Liberar monto del ejecutado al rechazar
            IF @Nuevo_Estado = 5
            BEGIN
                UPDATE Tbl_Detalle_Presupuesto
                SET Monto_Ejecutado = Monto_Ejecutado - @Monto_Gasto,
                    Fecha_Modificacion = SYSDATETIME(),
                    Id_Modificador = @Id_Usuario_Aprobador
                WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;

                -- Calcular nuevo porcentaje de ejecucion
                DECLARE @Nuevo_Monto_Ejecutado DECIMAL(18,2);
                DECLARE @Monto_Presupuestado DECIMAL(18,2);
                
                SELECT @Nuevo_Monto_Ejecutado = Monto_Ejecutado,
                       @Monto_Presupuestado = Monto_Presupuestado
                FROM Tbl_Detalle_Presupuesto 
                WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;

                DECLARE @Porcentaje DECIMAL(5,2);
                IF @Monto_Presupuestado > 0
                    SET @Porcentaje = (@Nuevo_Monto_Ejecutado / @Monto_Presupuestado) * 100.00;
                ELSE
                    SET @Porcentaje = 0.00;

                -- Desactivar alertas si baja del 85
                IF @Porcentaje <= 85.00
                BEGIN
                    UPDATE Tbl_Alertas
                    SET Leida = 1,
                        Id_Estado = 2
                    WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle AND Leida = 0 AND Id_Estado = 1;
                END;
            END;
        END;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Aprobacion registrada y flujo procesado correctamente';
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

-- Insertar primero un gasto pendiente temporal para aprobar
INSERT INTO Tbl_Gastos (Id_Presupuesto_Detalle, Id_Tipo_Gasto, Descripcion_Gasto, Monto_Gasto, Id_Proveedor, Id_Creador, Id_Estado)
VALUES (1, 16, 'Gasto de pruebas aprobacion', 500.00, 13, 3, 3); -- ID temporal generado

DECLARE @v_Gasto_Id INT = SCOPE_IDENTITY();

EXEC sp_Tbl_Aprobaciones_Crear
    @Id_Presupuesto = NULL,
    @Id_Gasto = @v_Gasto_Id,
    @Id_Usuario_Aprobador = 2, -- Gerente Financiero
    @Id_Resultado_Aprobacion = 11, -- Autorizado
    @Comentarios = 'Aprobado satisfactoriamente',
    @Id_Creador = 2,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS AprobacionIdGenerada;
GO
