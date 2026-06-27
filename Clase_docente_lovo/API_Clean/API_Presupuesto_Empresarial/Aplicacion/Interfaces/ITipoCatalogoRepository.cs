using Domain.TipoCatalogo;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface ITipoCatalogoRepository
    {
        Task<IEnumerable<DM_Tipo_Catalogo_listar>> Listar_Cat_Tipo_CatalogoAsync();
        Task<IEnumerable<DM_Tipo_Catalogo_listar>> Filtrar_Cat_Tipo_CatalogoAsync(DM_Tipo_Catalogo_filtrar modelo);
        Task<DBResult> Crear_Cat_Tipo_CatalogoAsync(DM_Tipo_Catalogo_crear modelo);
        Task<DBResult> Actualizar_Cat_Tipo_CatalogoAsync(DM_Tipo_Catalogo_actualizar modelo);
        Task<DBResult> Eliminar_Cat_Tipo_CatalogoAsync(DM_Tipo_Catalogo_eliminar modelo);
    }
}
