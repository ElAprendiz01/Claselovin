using System;

namespace Aplicacion.DTOs.Presupuesto
{
    public class PresupuestoFiltrarDTOs
    {
        public string? SearchTerm { get; set; }
        public int? Id_Presupuesto { get; set; }
        public int? Anio_Fiscal { get; set; }
    }
}
