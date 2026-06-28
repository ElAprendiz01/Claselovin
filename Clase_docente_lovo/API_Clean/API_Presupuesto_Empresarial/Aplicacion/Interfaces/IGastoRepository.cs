using Domain.Gasto;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface IGastoRepository
    {
        Task<IEnumerable<DM_Gasto_listar>> Listar_GastoAsync();
        Task<IEnumerable<DM_Gasto_listar>> Filtrar_GastoAsync(DM_Gasto_filtrar modelo);
        Task<DBResult> Crear_GastoAsync(DM_Gasto_crear modelo);
        Task<DBResult> Actualizar_GastoAsync(DM_Gasto_actualizar modelo);
        Task<DBResult> Eliminar_GastoAsync(DM_Gasto_eliminar modelo);
    }
}
