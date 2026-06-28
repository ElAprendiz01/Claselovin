using Domain.CentroCosto;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface ICentroCostoRepository
    {
        Task<IEnumerable<DM_CentroCosto_listar>> Listar_Cat_CentrosCostoAsync();
        Task<IEnumerable<DM_CentroCosto_listar>> Filtrar_Cat_CentrosCostoAsync(DM_CentroCosto_filtrar modelo);
        Task<DBResult> Crear_Cat_CentrosCostoAsync(DM_CentroCosto_crear modelo);
        Task<DBResult> Actualizar_Cat_CentrosCostoAsync(DM_CentroCosto_actualizar modelo);
        Task<DBResult> Eliminar_Cat_CentrosCostoAsync(DM_CentroCosto_eliminar modelo);
    }
}
