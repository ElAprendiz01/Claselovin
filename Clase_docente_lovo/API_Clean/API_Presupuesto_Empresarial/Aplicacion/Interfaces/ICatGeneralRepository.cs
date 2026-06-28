using Domain.CatalogoGeneral;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface ICatGeneralRepository
    {
        Task<IEnumerable<DM_Cat_General_listar>> Listar_Cat_GeneralAsync();
        Task<IEnumerable<DM_Cat_General_listar>> Filtrar_Cat_GeneralAsync(DM_Cat_General_filtrar modelo);
        Task<DBResult> Crear_Cat_GeneralAsync(DM_Cat_General_crear modelo);
        Task<DBResult> Actualizar_Cat_GeneralAsync(DM_Cat_General_actualizar modelo);
        Task<DBResult> Eliminar_Cat_GeneralAsync(DM_Cat_General_eliminar modelo);
    }
}
