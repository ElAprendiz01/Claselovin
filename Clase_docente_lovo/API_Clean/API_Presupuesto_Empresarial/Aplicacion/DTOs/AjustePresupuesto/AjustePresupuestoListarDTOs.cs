using System;

namespace Aplicacion.DTOs.AjustePresupuesto
{
    public class AjustePresupuestoListarDTOs
    {
        public int? Id_Ajuste { get; set; }
        public int? Id_Presupuesto_Detalle { get; set; }
        public int? Id_Presupuesto { get; set; }
        public int? Anio_Fiscal { get; set; }
        public string? Nombre_Centro { get; set; }
        public string? Nombre_Categoria_Gasto { get; set; }
        public string? Tipo_Ajuste { get; set; }
        public decimal? Monto_Ajuste { get; set; }
        public string? Justificacion { get; set; }
        public DateTime? Fecha_Ajuste { get; set; }
        public int? Id_Creador { get; set; }
    }
}
