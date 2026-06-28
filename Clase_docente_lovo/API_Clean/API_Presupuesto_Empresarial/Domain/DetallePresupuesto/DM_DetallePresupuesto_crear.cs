using System;

namespace Domain.DetallePresupuesto
{
    public class DM_DetallePresupuesto_crear
    {
        public int? Id_Presupuesto { get; set; }
        public int? Id_Centro_Costo { get; set; }
        public int? Id_Categoria_Gasto { get; set; }
        public decimal? Monto_Presupuestado { get; set; }
        public int? Id_Creador { get; set; }
    }
}
