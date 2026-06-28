using System;

namespace Aplicacion.DTOs.Gasto
{
    public class GastoActualizarDTOs
    {
        public int? Id_Gasto { get; set; }
        public int? Id_Tipo_Gasto { get; set; }
        public string? Descripcion_Gasto { get; set; }
        public decimal? Monto_Gasto { get; set; }
        public DateTime? Fecha_Gasto { get; set; }
        public string? Numero_Factura { get; set; }
        public int? Id_Proveedor { get; set; }
        public int? Id_Modificador { get; set; }
        public int? Id_Estado { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
