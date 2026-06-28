using System;

namespace Aplicacion.DTOs.Gasto
{
    public class GastoFiltrarDTOs
    {
        public string? SearchTerm { get; set; }
        public int? Id_Gasto { get; set; }
        public int? Id_Presupuesto_Detalle { get; set; }
    }
}
