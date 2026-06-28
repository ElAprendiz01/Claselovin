using System;

namespace Domain.DetallePresupuesto
{
    public class DM_DetallePresupuesto_listar
    {
        public int? Id_Presupuesto_Detalle { get; set; }
        public int? Id_Presupuesto { get; set; }
        public int? Anio_Fiscal { get; set; }
        public int? Id_Centro_Costo { get; set; }
        public string? Nombre_Centro { get; set; }
        public string? Codigo_Contable { get; set; }
        public int? Id_Departamento { get; set; }
        public string? Nombre_Departamento { get; set; }
        public int? Id_Categoria_Gasto { get; set; }
        public string? Nombre_Categoria_Gasto { get; set; }
        public decimal? Monto_Presupuestado { get; set; }
        public decimal? Monto_Ejecutado { get; set; }
        public decimal? Saldo_Disponible { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Modificador { get; set; }
        public DateTime? Fecha_Creacion { get; set; }
        public DateTime? Fecha_Modificacion { get; set; }
    }
}
