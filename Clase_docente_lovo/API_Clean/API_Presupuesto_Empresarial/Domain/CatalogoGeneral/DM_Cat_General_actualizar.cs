using System;

namespace Domain.CatalogoGeneral
{
    public class DM_Cat_General_actualizar
    {
        public int? Id_Catalogo { get; set; }
        public int? Id_Tipo_Catalogo { get; set; }
        public string? Nombre { get; set; }
        public int? Id_Modificador { get; set; }
        public bool? Activo { get; set; }
    }
}
