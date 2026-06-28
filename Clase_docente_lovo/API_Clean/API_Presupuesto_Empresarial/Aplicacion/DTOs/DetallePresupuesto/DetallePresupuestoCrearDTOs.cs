using System;

namespace Aplicacion.DTOs.DetallePresupuesto
{
    public class DetallePresupuestoCrearDTOs
    {
        public int? Id_Presupuesto { get; set; }
        public int? Id_Centro_Costo { get; set; }
        public int? Id_Categoria_Gasto { get; set; }
        public decimal? Monto_Presupuestado { get; set; }
        public int? Id_Creador { get; set; }
    }
}
