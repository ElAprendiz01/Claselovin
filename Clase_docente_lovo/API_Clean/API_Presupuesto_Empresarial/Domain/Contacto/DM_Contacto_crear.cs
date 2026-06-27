using System;

namespace Domain.Contacto
{
    public class DM_Contacto_crear
    {
        public int? Id_Persona { get; set; }
        public int? Id_Tipo_Contacto { get; set; }
        public string? Contacto { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Estado { get; set; }
    }
}
