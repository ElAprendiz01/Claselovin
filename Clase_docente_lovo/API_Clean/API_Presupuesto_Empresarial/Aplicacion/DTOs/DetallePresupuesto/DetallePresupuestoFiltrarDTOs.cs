using System;

namespace Aplicacion.DTOs.DetallePresupuesto
{
    public class DetallePresupuestoFiltrarDTOs
    {
        public string? SearchTerm { get; set; }
        public int? Id_Presupuesto_Detalle { get; set; }
        public int? Id_Presupuesto { get; set; }
    }
}
