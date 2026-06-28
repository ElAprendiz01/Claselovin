using System;

namespace Domain.Rol
{
    public class DM_Rol_actualizar
    {
        public int? Id_Rol { get; set; }
        public string? Nombre { get; set; }
        public string? Descripcion { get; set; }
        public int? Id_Modificador { get; set; }
        public int? Id_Estado { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
