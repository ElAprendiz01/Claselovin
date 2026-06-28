using System;

namespace Aplicacion.DTOs.DetallePresupuesto
{
    public class DetallePresupuestoActualizarDTOs
    {
        public int? Id_Presupuesto_Detalle { get; set; }
        public decimal? Monto_Presupuestado { get; set; }
        public int? Id_Modificador { get; set; }
    }
}
