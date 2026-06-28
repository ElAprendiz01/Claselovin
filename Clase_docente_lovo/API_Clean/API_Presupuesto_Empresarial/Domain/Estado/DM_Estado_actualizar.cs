using System;

namespace Domain.Estado
{
    public class DM_Estado_actualizar
    {
        public int? Id_Estado { get; set; }
        public string? Estado { get; set; }
        public int? Id_Modificador { get; set; }
        public bool? Activo { get; set; }
    }
}
