using System;

namespace Aplicacion.DTOs.Usuario
{
    public class UsuarioCrearDTOs
    {
        public string? Usuario { get; set; }
        public string? Contrasena { get; set; }
        public int? Id_Persona { get; set; }
        public int? Id_Rol { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Estado { get; set; }
    }
}
