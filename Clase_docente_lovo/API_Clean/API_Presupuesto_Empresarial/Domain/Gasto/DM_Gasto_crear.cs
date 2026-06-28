using System;

namespace Domain.Gasto
{
    public class DM_Gasto_crear
    {
        public int? Id_Presupuesto_Detalle { get; set; }
        public int? Id_Tipo_Gasto { get; set; }
        public string? Descripcion_Gasto { get; set; }
        public decimal? Monto_Gasto { get; set; }
        public DateTime? Fecha_Gasto { get; set; }
        public string? Numero_Factura { get; set; }
        public int? Id_Proveedor { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Estado { get; set; }
    }
}
