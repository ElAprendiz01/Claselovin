using System;

namespace Aplicacion.DTOs.Rol
{
    public class RolListarDTOs
    {
        public int? Id_Rol { get; set; }
        public string? Nombre { get; set; }
        public string? Descripcion { get; set; }
        public DateTime? Fecha_Creacion { get; set; }
        public DateTime? Fecha_Modificacion { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Modificador { get; set; }
        public int? Id_Estado { get; set; }
        public string? Nombre_Estado { get; set; }
    }
}
