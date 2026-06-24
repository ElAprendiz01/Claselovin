# Análisis y Metodología para Procedimientos Almacenados de Consulta (Listar/Filtrar)

Este documento define la estructura y el mapeo de parámetros para todos los stored procedures de consulta (`sp_*_Filtrar` / `sp_*_Listar`) en el sistema `Presupuesto_Empresarial`. El objetivo principal es optimizar las consultas y evitar la redundancia reutilizando y extendiendo las vistas generales existentes (`VW_*`) sin romper las dependencias de otros procedimientos.

---

## 1. Metodología de Diseño para Consultas

* **Uso de Vistas Centralizadas**: En lugar de que cada stored procedure de consulta realice sus propios `INNER JOIN` repetitivos para obtener descripciones de llaves foráneas, consumirán vistas unificadas.
* **Compatibilidad de Vistas**: Si a una vista le faltan campos descriptivos o técnicos (como campos de auditoría), se proponen adiciones al final de su select. Nunca se deben eliminar o renombrar columnas existentes en las vistas para no afectar a otros procedimientos que dependan de ellas.
* **Filtrado Dinámico Estándar**: Los SP de filtrado implementarán parámetros opcionales (`= NULL`) para realizar búsquedas específicas por ID o términos de texto generales (`@SearchTerm`).

---

## 2. Inventario de Tablas, Parámetros y Vistas

A continuación se detalla el mapeo para cada una de las 17 tablas del sistema:

### Catálogos Básicos (Sin Vistas Complejas)
Para los catálogos simples de pocos campos, no es necesario crear vistas adicionales; se resolverán directamente con consultas simples.

#### 1. Cat_Estado
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Estado INT = NULL`
* **Campos Retornados**: `Id_Estado`, `Estado`, `Activo`
* **Vista Asociada**: Ninguna (consulta directa).

#### 2. Cat_Tipo_Catalogo
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Tipo_Catalogo INT = NULL`
* **Campos Retornados**: `Id_Tipo_Catalogo`, `Nombre_Tipo`, `Activo`
* **Vista Asociada**: Ninguna (consulta directa).

#### 3. Cat_General
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Catalogo INT = NULL`, `@Id_Tipo_Catalogo INT = NULL`
* **Campos Retornados**: `Id_Catalogo`, `Id_Tipo_Catalogo`, `Nombre_Tipo` (de `Cat_Tipo_Catalogo`), `Nombre`, `Activo`
* **Vista Asociada**: Ninguna (consulta directa con `INNER JOIN` simple a `Cat_Tipo_Catalogo`).

#### 4. Cat_Monedas
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Moneda INT = NULL`
* **Campos Retornados**: `Id_Moneda`, `Nombre`, `Codigo_ISO`, `Simbolo`, `Activo`
* **Vista Asociada**: Ninguna (consulta directa).

---

### Tablas Transaccionales y de Entidades

#### 5. Tbl_Roles
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Rol INT = NULL`
* **Campos Retornados**: `Id_Rol`, `Nombre`, `Descripcion`, `Fecha_Creacion`, `Fecha_Modificacion`, `Id_Creador`, `Id_Modificador`, `Id_Estado`, `Nombre_Estado` (de `Cat_Estado`)
* **Vista Asociada**: Ninguna (consulta directa con `INNER JOIN` a `Cat_Estado`).

#### 6. Tbl_Datos_Personales
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Persona INT = NULL`
* **Campos de Llave Foránea a Resolver**:
  * `Id_Tipo_DNI` $\rightarrow$ `Tipo_DNI` (de `Cat_General`)
  * `Id_Genero` $\rightarrow$ `Genero` (de `Cat_General`)
  * `Id_Estado` $\rightarrow$ `Nombre_Estado` (de `Cat_Estado`)
* **Campos Calculados**: `Nombre_Completo` (concatenación)
* **Vista Asociada**: `VW_Datos_Personales_General` (Propuesta de nueva vista, o bien consumir de `VW_Usuarios_Personal_General` si solo se listan personas con usuario).

#### 7. Tbl_Contacto
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Contacto INT = NULL`, `@Id_Persona INT = NULL`
* **Campos de Llave Foránea a Resolver**:
  * `Id_Persona` $\rightarrow$ `Nombre_Persona` (de `Tbl_Datos_Personales`)
  * `Id_Tipo_Contacto` $\rightarrow$ `Nombre_Tipo_Contacto` (de `Cat_General`)
  * `Id_Estado` $\rightarrow$ `Nombre_Estado` (de `Cat_Estado`)
* **Vista Asociada**: `VW_Contactos_General` (Propuesta de nueva vista para unificar contactos y nombres de personas).

#### 8. Tbl_Usuarios
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Usuario INT = NULL`, `@Id_Rol INT = NULL`
* **Campos de Llave Foránea a Resolver**:
  * `Id_Persona` $\rightarrow$ `Nombre_Completo`, `DNI` (de `Tbl_Datos_Personales`)
  * `Id_Rol` $\rightarrow$ `Nombre_Rol` (de `Tbl_Roles`)
  * `Id_Estado` $\rightarrow$ `Estado_Usuario` (de `Cat_Estado`)
* **Vista Asociada**: `VW_Usuarios_Personal_General`
* **Propuesta de Adición a la Vista**:
  * Agregar `U.Fecha_Creacion`, `U.Fecha_Modificacion`, `U.Id_Creador` e `U.Id_Modificador` a la vista para que el SP de listar pueda proveer estos metadatos técnicos.

#### 9. Tbl_Permisos_Opciones
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Permiso INT = NULL`, `@Id_Rol INT = NULL`
* **Campos de Llave Foránea a Resolver**:
  * `Id_Rol` $\rightarrow$ `Nombre_Rol` (de `Tbl_Roles`)
* **Vista Asociada**: Ninguna (consulta con `INNER JOIN` directo a `Tbl_Roles` es suficiente por su simpleza).

#### 10. Tbl_Departamentos
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Departamento INT = NULL`
* **Campos de Llave Foránea a Resolver**:
  * `Id_Estado` $\rightarrow$ `Estado_Depto` (de `Cat_Estado`)
* **Vista Asociada**: `VW_Estructura_Organizacional_General` (filtrando departamentos únicos).

#### 11. Tbl_Centros_Costo
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Centro_Costo INT = NULL`, `@Id_Departamento INT = NULL`
* **Campos de Llave Foránea a Resolver**:
  * `Id_Departamento` $\rightarrow$ `Nombre_Departamento`, `Codigo_Depto`
  * `Id_Estado` $\rightarrow$ `Estado_Centro`
* **Vista Asociada**: `VW_Estructura_Organizacional_General`

#### 12. Tbl_Presupuestos
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Presupuesto INT = NULL`
* **Campos de Llave Foránea a Resolver**:
  * `Id_Moneda` $\rightarrow$ `Moneda_ISO`, `Moneda_Simbolo` (de `Cat_Monedas`)
  * `Id_Estado` $\rightarrow$ `Estado_Presupuesto` (de `Cat_Estado`)
* **Vista Asociada**: `VW_Presupuestos_Detalle_General` (agrupada o creando una vista simplificada de cabeceras de presupuesto `VW_Presupuestos_Cabecera_General`).

#### 13. Tbl_Detalle_Presupuesto
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Presupuesto_Detalle INT = NULL`, `@Id_Presupuesto INT = NULL`
* **Campos de Llave Foránea a Resolver**:
  * `Id_Presupuesto` $\rightarrow$ `Anio_Fiscal`, `Descripcion_Presupuesto`
  * `Id_Centro_Costo` $\rightarrow$ `Nombre_Centro`, `Codigo_Centro`
  * `Id_Categoria_Gasto` $\rightarrow$ `Categoria_Gasto`
* **Campos Calculados**: `Saldo_Disponible`
* **Vista Asociada**: `VW_Presupuestos_Detalle_General`

#### 14. Tbl_Ajustes_Presupuesto
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Ajuste INT = NULL`, `@Id_Presupuesto_Detalle INT = NULL`
* **Campos de Llave Foránea a Resolver**:
  * `Id_Presupuesto_Detalle` $\rightarrow$ `Nombre_Centro`, `Nombre_Categoria_Gasto`, `Anio_Fiscal`
  * `Id_Creador` $\rightarrow$ `Usuario`
* **Vista Asociada**: `VW_Ajustes_Presupuesto_General` (Propuesta de nueva vista).

#### 15. Tbl_Gastos
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Gasto INT = NULL`, `@Id_Presupuesto_Detalle INT = NULL`
* **Campos de Llave Foránea a Resolver**:
  * `Id_Presupuesto_Detalle` $\rightarrow$ `Anio_Fiscal`, `Nombre_Centro`, `Nombre_Departamento`
  * `Id_Proveedor` $\rightarrow$ `Proveedor` (de `Cat_General`)
  * `Id_Tipo_Gasto` $\rightarrow$ `Tipo_Gasto` (de `Cat_General`)
  * `Id_Estado` $\rightarrow$ `Estado_Gasto` (de `Cat_Estado`)
* **Vista Asociada**: `VW_Gastos_Transaccionales_General`

#### 16. Tbl_Aprobaciones
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Aprobacion INT = NULL`, `@Id_Presupuesto INT = NULL`, `@Id_Gasto INT = NULL`
* **Campos de Llave Foránea a Resolver**:
  * `Id_Usuario_Aprobador` $\rightarrow$ `Nombre_Aprobador` (de `Tbl_Datos_Personales` vía `Tbl_Usuarios`)
  * `Id_Resultado_Aprobacion` $\rightarrow$ `Resultado_Aprobacion` (de `Cat_General`)
* **Vista Asociada**: `VW_Auditoria_Aprobaciones_General`

#### 17. Tbl_Alertas
* **Parámetros del SP**: `@SearchTerm VARCHAR(50) = NULL`, `@Id_Alerta INT = NULL`, `@Id_Presupuesto_Detalle INT = NULL`
* **Campos de Llave Foránea a Resolver**:
  * `Id_Presupuesto_Detalle` $\rightarrow$ `Nombre_Centro`, `Nombre_Departamento` (de `Tbl_Detalle_Presupuesto`)
  * `Id_Estado` $\rightarrow$ `Nombre_Estado` (de `Cat_Estado`)
* **Vista Asociada**: `VW_Alertas_General` (Propuesta de nueva vista).

---

## 3. Ejemplo Estándar de Implementación de SP Listar

A continuación se muestra la estructura recomendada para un SP de tipo Listar que consume una vista:

```sql
CREATE OR ALTER PROCEDURE sp_Tbl_Usuarios_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos utilizando vista
    SELECT 
        Id_Usuario,
        Usuario,
        Id_Rol,
        Nombre_Rol,
        Id_Persona,
        Nombre_Completo,
        DNI,
        Tipo_DNI,
        Genero,
        Fecha_Nacimiento,
        Estado_Usuario,
        Id_Estado_Usuario
    FROM VW_Usuarios_Personal_General (NOLOCK);
END;
GO
```
