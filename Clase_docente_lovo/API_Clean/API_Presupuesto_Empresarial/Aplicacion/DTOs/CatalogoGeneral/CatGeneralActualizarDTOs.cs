using System;

namespace Aplicacion.DTOs.CatalogoGeneral
{
    public class CatGeneralActualizarDTOs
    {
        public int? Id_Catalogo { get; set; }
        public int? Id_Tipo_Catalogo { get; set; }
        public string? Nombre { get; set; }
        public int? Id_Modificador { get; set; }
        public bool? Activo { get; set; }
    }
}
