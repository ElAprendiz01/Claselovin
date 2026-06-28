using System;

namespace Aplicacion.DTOs.Rol
{
    public class RolCrearDTOs
    {
        public string? Nombre { get; set; }
        public string? Descripcion { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Estado { get; set; }
    }
}
