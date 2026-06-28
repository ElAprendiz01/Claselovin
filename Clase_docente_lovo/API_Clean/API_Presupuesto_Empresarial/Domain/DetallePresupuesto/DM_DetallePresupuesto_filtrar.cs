using System;

namespace Domain.DetallePresupuesto
{
    public class DM_DetallePresupuesto_filtrar
    {
        public string? SearchTerm { get; set; }
        public int? Id_Presupuesto_Detalle { get; set; }
        public int? Id_Presupuesto { get; set; }
    }
}
