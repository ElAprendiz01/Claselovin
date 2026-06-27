using Domain.DatosPersonales;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface IDatosPersonalesRepository
    {
        Task<IEnumerable<DM_DatosPersonales_listar>> Listar_Cat_DatosPersonalesAsync();
        Task<IEnumerable<DM_DatosPersonales_listar>> Filtrar_Cat_DatosPersonalesAsync(DM_DatosPersonales_filtrar modelo);
        Task<DBResult> Crear_Cat_DatosPersonalesAsync(DM_DatosPersonales_crear modelo);
        Task<DBResult> Actualizar_Cat_DatosPersonalesAsync(DM_DatosPersonales_actualizar modelo);
        Task<DBResult> Eliminar_Cat_DatosPersonalesAsync(DM_DatosPersonales_eliminar modelo);
    }
}
