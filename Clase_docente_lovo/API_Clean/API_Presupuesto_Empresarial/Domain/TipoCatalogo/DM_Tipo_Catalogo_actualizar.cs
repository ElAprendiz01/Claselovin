using System;

namespace Domain.TipoCatalogo
{
    public class DM_Tipo_Catalogo_actualizar
    {
        public int? Id_Tipo_Catalogo { get; set; }
        public string? Nombre { get; set; }
        public int? Id_Modificador { get; set; }
        public bool? Activo { get; set; }
    }
}
