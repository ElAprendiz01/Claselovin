using System;

namespace Aplicacion.DTOs.Rol
{
    public class RolActualizarDTOs
    {
        public int? Id_Rol { get; set; }
        public string? Nombre { get; set; }
        public string? Descripcion { get; set; }
        public int? Id_Modificador { get; set; }
        public int? Id_Estado { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
