using System;

namespace Aplicacion.DTOs.Contacto
{
    public class ContactoCrearDTOs
    {
        public int? Id_Persona { get; set; }
        public int? Id_Tipo_Contacto { get; set; }
        public string? Contacto { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Estado { get; set; }
    }
}
