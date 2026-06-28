using System;

namespace Domain.DetallePresupuesto
{
    public class DM_DetallePresupuesto_actualizar
    {
        public int? Id_Presupuesto_Detalle { get; set; }
        public decimal? Monto_Presupuestado { get; set; }
        public int? Id_Modificador { get; set; }
    }
}
