using Domain.Moneda;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface IMonedaRepository
    {
        Task<IEnumerable<DM_Moneda_listar>> Listar_Cat_MonedasAsync();
        Task<IEnumerable<DM_Moneda_listar>> Filtrar_Cat_MonedasAsync(DM_Moneda_filtrar modelo);
        Task<DBResult> Crear_Cat_MonedasAsync(DM_Moneda_crear modelo);
        Task<DBResult> Actualizar_Cat_MonedasAsync(DM_Moneda_actualizar modelo);
        Task<DBResult> Eliminar_Cat_MonedasAsync(DM_Moneda_eliminar modelo);
    }
}
