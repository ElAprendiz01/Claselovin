using Domain.AjustePresupuesto;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface IAjustePresupuestoRepository
    {
        Task<IEnumerable<DM_AjustePresupuesto_listar>> Listar_AjustePresupuestoAsync();
        Task<IEnumerable<DM_AjustePresupuesto_listar>> Filtrar_AjustePresupuestoAsync(DM_AjustePresupuesto_filtrar modelo);
        Task<DBResult> Crear_AjustePresupuestoAsync(DM_AjustePresupuesto_crear modelo);
    }
}
