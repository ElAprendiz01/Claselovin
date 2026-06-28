using System;

namespace Domain.Contacto
{
    public class DM_Contacto_actualizar
    {
        public int? Id_Contacto { get; set; }
        public int? Id_Persona { get; set; }
        public int? Id_Tipo_Contacto { get; set; }
        public string? Contacto { get; set; }
        public int? Id_Modificador { get; set; }
        public int? Id_Estado { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
