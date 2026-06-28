using System;

namespace Aplicacion.DTOs.Estado
{
    public class EstadoActualizarDTOs
    {
        public int? Id_Estado { get; set; }
        public string? Estado { get; set; }
        public int? Id_Modificador { get; set; }
        public bool? Activo { get; set; }
    }
}
